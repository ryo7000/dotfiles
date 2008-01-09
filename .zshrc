autoload -U compinit promptinit
compinit;
promptinit;

# cache
zstyle ':completion::complete:*' use-cache 1

# vi編集モード
bindkey -v
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^R' history-incremental-search-backward

# http://d.hatena.ne.jp/cooldaemon/searchdiary?word=*%5Bzsh%5D
# http://hatena.g.hatena.ne.jp/hatenatech/20060517/1147833430

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加する
setopt append_history

# 指定したコマンド名がなく、ディレクトリ名と一致した場合 cd する
setopt auto_cd

# 補完候補が複数ある時に、一覧表示する
setopt auto_list

# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt auto_menu

# カッコの対応などを自動的に補完する
setopt auto_param_keys

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# ビープ音を鳴らさないようにする
setopt NO_beep

# {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl

# コマンドのスペルチェックをする
setopt correct

# =command を command のパス名に展開する
setopt equals

# ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob

# Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt no_flow_control
stty -ixon

# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups

# コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify

# シェルが終了しても裏ジョブに HUP シグナルを送らないようにする
setopt NO_hup

# コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments

# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示
setopt list_types

# 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs

# ファイル名の展開で、辞書順ではなく数値的にソートされるようになる
setopt numeric_glob_sort

# 8 ビット目を通すようになり、日本語のファイル名などを見れるようになる
setopt print_eightbit

# シェルのプロセスごとに履歴を共有
setopt share_history

# history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store

# 文字列末尾に改行コードが無い場合でも表示する
unsetopt promptcr

#コピペの時rpromptを非表示する
setopt transient_rprompt

# cd -[tab] でpushd
setopt autopushd

# 重複ディレクトリはpushdしない
setopt pushd_ignore_dups

# 履歴ファイルに時刻を記録
setopt extended_history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

# prompt設定
# 色を使う
setopt prompt_subst

autoload -U colors; colors
PROMPT='${WINDOW:+"[$WINDOW]"}%{$fg[green]%}`whoami`@`hostname` %#%{$reset_color%} '
RPROMPT='%{$fg[yellow]%}[%(4~,%-1~/.../%2~,%~)%{$fg[red]%}:%!%{$fg[yellow]%}]%{$reset_color%}'

## import from Gentoo .bashrc
# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
if [[ -f ~/.dir_colors ]] ; then
	eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]] ; then
	eval $(dircolors -b /etc/DIR_COLORS)
fi

# Change the window title of X terminals 
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

export LANG="ja_JP.eucJP"
export MANPAGER="less -r"
export SVN_EDITOR="vim"
export PATH="$HOME/bin:$PATH"

# psqlの出力エンコーディング設定
export PGCLIENTENCODING="EUC-JP"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# colors for ls, etc.
alias d="ls --color"
alias ls="ls --color=auto -F"
alias ll="ls --color -l"
alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"
alias google="w3m www.google.co.jp"
alias apnic="w3m http://ftp.apnic.net/stats/apnic/"

alias mobileimap='mobileimap -d -a LOGIN -s www.live-emotion.com -i 05001010277945_ab.ezweb.ne.jp'

alias mboxtrain='/usr/bin/sb_mboxtrain.py -n -g ~/Maildir/.Bayes.ham/ -s ~/Maildir/.Bayes.spam/'
alias -g TIME="| awk '{print strftime(\"%Y-%m-%d %H:%M:%S\",\$1)}'"
