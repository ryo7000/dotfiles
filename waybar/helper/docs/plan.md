## 作業の目的・背景

waybarから音量調節など、様々なコマンドを呼び出すためのhelperコマンドを作ります。
シェルスクリプトを使うかわりにRustで作ります。

## 作業内容

Linuxで音量を上げ下げしたり、ミュートしたり解除するコマンドを作成します。
また、操作後はデスクトップ通知を表示します。

## 詳細仕様

### コマンド体系について

- clap crateのDerive形式でコマンドを定義します
- 様々なコマンドを作る想定のため、サブコマンドに関連したコマンドを作ります
- 今回作るサブコマンドは `audio` としてください
  - `audio input raise`:  microphone volume up 1%
  - `audio input lower`:  microphone volume down 1%
  - `audio input mute`:   toggle microphone mute
  - `audio output raise`: speaker volume up 1%
  - `audio output lower`: speaker volume down 1%
  - `audio output mute`:  toggle speaker mute

### audioの操作について

pulseaudioのインターフェースを使って操作をします。`pulsectl-rs`または類似のcrateを使って下さい

### 操作後の通知について

- `notify-rust` crateを使って通知をします
- `input`と`output`でアイコンを変更します
- toggle mute
  - 現在の状態に合わせてアイコンを変更します
  - 状態が更新された場合は、新しく通知を表示します
- raise/mute
  - 現在の値とスライドバーを表示します
  - 通知がすでに表示されている場合は、既存の通知を更新します

## 前提条件

- Rustのeditionは2024を使います
- targetはLinux, x86_64です
