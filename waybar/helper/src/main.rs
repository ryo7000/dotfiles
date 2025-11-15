use anyhow::{Context, Result, anyhow};
use clap::{Parser, Subcommand};
#[cfg(all(unix, not(target_os = "macos")))]
use notify_rust::Hint;
use notify_rust::Notification;
use pulsectl::controllers::types::DeviceInfo;
use pulsectl::controllers::{DeviceControl, SinkController, SourceController};

const APP_NAME: &str = "waybar-helper";
const VOLUME_STEP: f64 = 0.01;
const NORMAL_VOLUME_RAW: f64 = 65_536.0;
const OUTPUT_NOTIFICATION_ID: u32 = 0xA11CE;
const INPUT_NOTIFICATION_ID: u32 = 0xA11CF;

#[derive(Parser)]
#[command(
    name = "waybar-helper",
    author,
    version,
    about = "Utilities invoked by Waybar"
)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    #[command(subcommand)]
    Audio(AudioCommand),
}

#[derive(Subcommand)]
enum AudioCommand {
    #[command(subcommand)]
    Input(AudioAction),
    #[command(subcommand)]
    Output(AudioAction),
}

#[derive(Subcommand, Clone, Copy)]
enum AudioAction {
    Raise,
    Lower,
    Mute,
}

#[derive(Clone, Copy)]
enum AudioTarget {
    Input,
    Output,
}

#[derive(Clone, Copy)]
enum VolumeChange {
    Raise,
    Lower,
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    match cli.command {
        Commands::Audio(AudioCommand::Input(action)) => handle_audio(AudioTarget::Input, action),
        Commands::Audio(AudioCommand::Output(action)) => handle_audio(AudioTarget::Output, action),
    }
}

fn handle_audio(target: AudioTarget, action: AudioAction) -> Result<()> {
    match action {
        AudioAction::Raise => adjust_volume(target, VolumeChange::Raise),
        AudioAction::Lower => adjust_volume(target, VolumeChange::Lower),
        AudioAction::Mute => toggle_mute(target),
    }
}

fn adjust_volume(target: AudioTarget, change: VolumeChange) -> Result<()> {
    match target {
        AudioTarget::Output => adjust_sink_volume(change),
        AudioTarget::Input => adjust_source_volume(change),
    }
}

fn adjust_sink_volume(change: VolumeChange) -> Result<()> {
    let mut controller =
        SinkController::create().context("failed to connect to PulseAudio sink controller")?;
    let device = controller
        .get_default_device()
        .context("no default output device found")?;
    match change {
        VolumeChange::Raise => {
            controller.increase_device_volume_by_percent(device.index, VOLUME_STEP)
        }
        VolumeChange::Lower => {
            controller.decrease_device_volume_by_percent(device.index, VOLUME_STEP)
        }
    }
    let updated = controller
        .get_device_by_index(device.index)
        .context("failed to refresh output device state")?;
    send_volume_notification(AudioTarget::Output, &updated)
}

fn adjust_source_volume(change: VolumeChange) -> Result<()> {
    let mut controller =
        SourceController::create().context("failed to connect to PulseAudio source controller")?;
    let device = get_default_source(&mut controller)?;
    match change {
        VolumeChange::Raise => {
            controller.increase_device_volume_by_percent(device.index, VOLUME_STEP)
        }
        VolumeChange::Lower => {
            controller.decrease_device_volume_by_percent(device.index, VOLUME_STEP)
        }
    }
    let updated = controller
        .get_device_by_index(device.index)
        .context("failed to refresh input device state")?;
    send_volume_notification(AudioTarget::Input, &updated)
}

fn toggle_mute(target: AudioTarget) -> Result<()> {
    match target {
        AudioTarget::Output => toggle_sink_mute(),
        AudioTarget::Input => toggle_source_mute(),
    }
}

fn toggle_sink_mute() -> Result<()> {
    let mut controller =
        SinkController::create().context("failed to connect to PulseAudio sink controller")?;
    let device = controller
        .get_default_device()
        .context("no default output device found")?;
    let new_state = !device.mute;
    controller.set_device_mute_by_index(device.index, new_state);
    let updated = controller
        .get_device_by_index(device.index)
        .context("failed to refresh output device state")?;
    if updated.mute != device.mute {
        send_mute_notification(AudioTarget::Output, updated.mute)?;
    }
    Ok(())
}

fn toggle_source_mute() -> Result<()> {
    let mut controller =
        SourceController::create().context("failed to connect to PulseAudio source controller")?;
    let device = get_default_source(&mut controller)?;
    let new_state = !device.mute;
    set_source_mute(&mut controller, device.index, new_state)
        .context("failed to toggle microphone mute state")?;
    let updated = controller
        .get_device_by_index(device.index)
        .context("failed to refresh input device state")?;
    if updated.mute != device.mute {
        send_mute_notification(AudioTarget::Input, updated.mute)?;
    }
    Ok(())
}

fn get_default_source(controller: &mut SourceController) -> Result<DeviceInfo> {
    let server_info = controller
        .get_server_info()
        .context("failed to get PulseAudio server info")?;
    let name = server_info
        .default_source_name
        .as_ref()
        .cloned()
        .ok_or_else(|| anyhow!("no default input device configured"))?;
    controller
        .get_device_by_name(&name)
        .context("failed to get default input device")
}

fn set_source_mute(controller: &mut SourceController, index: u32, mute: bool) -> Result<()> {
    // pulsectl-rs 0.3.2 routes source mute calls through sink helpers, so call the handler directly.
    let op = controller
        .handler
        .introspect
        .set_source_mute_by_index(index, mute, None);
    controller
        .handler
        .wait_for_operation(op)
        .map_err(|err| anyhow!(err))?;
    Ok(())
}

fn send_volume_notification(target: AudioTarget, device: &DeviceInfo) -> Result<()> {
    let percent = device_percent(device);
    let icon = icon_for_volume(target, device.mute, percent);
    let (summary, notification_id) = match target {
        AudioTarget::Input => ("Microphone", INPUT_NOTIFICATION_ID),
        AudioTarget::Output => ("Speakers", OUTPUT_NOTIFICATION_ID),
    };
    let mut notification = Notification::new();
    notification
        .appname(APP_NAME)
        .summary(summary)
        .body(&format!("{percent:.0}%"))
        .icon(icon)
        .id(notification_id);
    #[cfg(all(unix, not(target_os = "macos")))]
    {
        apply_slider_hints(&mut notification, percent);
    }
    notification.show()?;
    Ok(())
}

#[cfg(all(unix, not(target_os = "macos")))]
fn apply_slider_hints(notification: &mut Notification, percent: f64) {
    let slider_value = percent.round().clamp(0.0, 100.0) as i32;
    notification
        .hint(Hint::CustomInt("value".into(), slider_value))
        .hint(Hint::CustomInt("min".into(), 0))
        .hint(Hint::CustomInt("max".into(), 100));
}

fn send_mute_notification(target: AudioTarget, muted: bool) -> Result<()> {
    let (summary, body) = match (target, muted) {
        (AudioTarget::Input, true) => ("Microphone", "Microphone muted"),
        (AudioTarget::Input, false) => ("Microphone", "Microphone unmuted"),
        (AudioTarget::Output, true) => ("Speakers", "Speakers muted"),
        (AudioTarget::Output, false) => ("Speakers", "Speakers unmuted"),
    };
    let icon = match (target, muted) {
        (AudioTarget::Input, true) => "microphone-sensitivity-muted",
        (AudioTarget::Input, false) => "microphone-sensitivity-high",
        (AudioTarget::Output, true) => "audio-volume-muted",
        (AudioTarget::Output, false) => "audio-volume-high",
    };
    Notification::new()
        .appname(APP_NAME)
        .summary(summary)
        .body(body)
        .icon(icon)
        .show()?;
    Ok(())
}

fn device_percent(device: &DeviceInfo) -> f64 {
    let avg = device.volume.avg();
    let percent = (avg.0 as f64 / NORMAL_VOLUME_RAW) * 100.0;
    percent.clamp(0.0, 150.0)
}

fn icon_for_volume(target: AudioTarget, muted: bool, percent: f64) -> &'static str {
    if muted || percent <= 0.1 {
        return match target {
            AudioTarget::Input => "microphone-sensitivity-muted",
            AudioTarget::Output => "audio-volume-muted",
        };
    }
    match target {
        AudioTarget::Input => {
            if percent < 50.0 {
                "microphone-sensitivity-low"
            } else {
                "microphone-sensitivity-high"
            }
        }
        AudioTarget::Output => {
            if percent < 34.0 {
                "audio-volume-low"
            } else if percent < 67.0 {
                "audio-volume-medium"
            } else {
                "audio-volume-high"
            }
        }
    }
}
