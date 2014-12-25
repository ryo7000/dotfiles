# 参考ページ
# http://d.hatena.ne.jp/cooldaemon/searchdiary?word=*%5Bzsh%5D
# http://hatena.g.hatena.ne.jp/hatenatech/20060517/1147833430
# http://www.ayu.ics.keio.ac.jp/~mukai/translate/zshoptions.html
# http://zshwiki.org/home/

# --------------------------------------------------------------------------------
# 環境変数
# --------------------------------------------------------------------------------

## import from Gentoo .bashrc
# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
if [[ -f ~/.dir_colors ]] ; then
	eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]] ; then
	eval $(dircolors -b /etc/DIR_COLORS)
fi

# timeの表示をbashっぽくする
export TIMEFMT=$'%J : \n real\t%*Es\n user\t%*Us\n sys \t%*Ss\n cpu \t%P'

export EDITOR="vim"
export PATH=$HOME/bin:$PATH

# 重複したPATHを削除
typeset -U path

# --------------------------------------------------------------------------------
# キー設定
# --------------------------------------------------------------------------------

# vi編集モード
bindkey -v

# 履歴表示の後、カーソルを末尾に
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Ctrl-p, n, ↑, ↓で前方一致検索
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
bindkey '^[[A' history-beginning-search-backward-end # ↑キー
bindkey '^[[B' history-beginning-search-forward-end  # ↓キー

# Ctrl-eで、過去の最後の引数を挿入
bindkey '^E' insert-last-word

if which peco > /dev/null; then
    # pecoでcdrを使う
    zle -N peco-cdr
    bindkey '^J' peco-cdr

    # search with peco
    zle -N peco-select-history
    bindkey '^R' peco-select-history
else
    # Ctrl-rでインクリメンタルサーチ (*等でAnd検索可能に)
    bindkey '^R' history-incremental-pattern-search-backward
fi

# --------------------------------------------------------------------------------
# 補完設定
# --------------------------------------------------------------------------------

# 標準の補完設定
autoload -U compinit
compinit

# cache
zstyle ':completion::complete:*' use-cache 1

# ファイル補完時にも色付け
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 補完候補が複数ある時に、一覧表示する
setopt auto_list

# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt auto_menu

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示
setopt list_types

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

# 補完候補を ←↓↑→ で選択 (補完候補が色分け表示される)
zstyle ':completion:*:default' menu select=1

# Termに表示されている内容から補完
# from http://qiita.com/hamaco/items/4eb19da6cf216104adf0
HARDCOPYFILE=$HOME/.tmux-hardcopy
touch $HARDCOPYFILE

dabbrev-complete () {
        local reply lines=80 # 80行分
        tmux capture-pane && tmux save-buffer -b 0 $HARDCOPYFILE && tmux delete-buffer -b 0
        reply=($(sed '/^$/d' $HARDCOPYFILE | sed '$ d' | tail -$lines))
        compadd -Q - "${reply[@]%[*/=@|]}"
}

zle -C dabbrev-complete menu-complete dabbrev-complete
bindkey '^o' dabbrev-complete
bindkey '^o^_' reverse-menu-complete

# --------------------------------------------------------------------------------
# hisotry設定
# --------------------------------------------------------------------------------

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加する
setopt append_history

# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups

# コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify

# シェルのプロセスごとに履歴を共有
setopt share_history

# history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store

# 履歴ファイルに時刻を記録
setopt extended_history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER" | sed 's@\\n@\n@g' )
    CURSOR=$#BUFFER
    zle clear-screen
}

# --------------------------------------------------------------------------------
# cd設定
# --------------------------------------------------------------------------------

# 指定したコマンド名がなく、ディレクトリ名と一致した場合 cd する
setopt auto_cd

# cdでpushdに置き換え
setopt autopushd

# 重複ディレクトリはpushdしない
setopt pushd_ignore_dups

# cd履歴を使うcdrコマンドを有効化
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 500
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':completion:*' recent-dirs-insert both
fi

function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

# --------------------------------------------------------------------------------
# 展開関連設定
# --------------------------------------------------------------------------------

# {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl

# =command を command のパス名に展開する
setopt equals

# ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs

# ファイル名の展開で、辞書順ではなく数値的にソートされるようになる
setopt numeric_glob_sort

# globにマッチしない場合に、標準出力にエラーを表示しない
setopt nonomatch

# --------------------------------------------------------------------------------
# prompt設定
# --------------------------------------------------------------------------------

# コピペの時rpromptを非表示する
setopt transient_rprompt

# プロンプト文字列で各種展開を行う
setopt prompt_subst

autoload -U colors; colors

case ${UID} in
	0)
		PROMPT='${WINDOW:+"[$WINDOW]"}%{$fg[red]%}%n@%m %#%{$reset_color%} '
		;;
	*)
		PROMPT='${WINDOW:+"[$WINDOW]"}%{$fg[green]%}%n@%m %#%{$reset_color%} '
		;;
esac
RPROMPT_DEFAULT='%{$fg[yellow]%}[%~]%{$reset_color%}'
RPROMPT=$RPROMPT_DEFAULT

# Change the window title of X terminals 
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

# --------------------------------------------------------------------------------
# その他設定
# --------------------------------------------------------------------------------

# カッコの対応などを自動的に補完する
setopt auto_param_keys

# ビープ音を鳴らさないようにする
setopt NO_beep

# コマンドのスペルチェックをする
setopt correct

# Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt no_flow_control
stty -ixon

# シェルが終了しても裏ジョブに HUP シグナルを送らないようにする
setopt NO_hup

# コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments

# 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

# 8 ビット目を通すようになり、日本語のファイル名などを見れるようになる
setopt print_eightbit

# 文字列末尾に改行コードが無い場合でも表示する
unsetopt promptcr


# colors for ls, etc.
alias d="ls --color"
alias ls="ls --color=auto -F"
alias ll="ls --color -F -l"
alias grep='grep --color=auto'
alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"
alias google="w3m www.google.co.jp"
alias nvim="vim --cmd \"set ei=FileType\""
alias tmux="tmux -2"

# unixtime to localtime
ut2date () {
	date -d "@${1}" +"%Y-%m-%d %H:%M:%S %Z"
	date -u -d "@${1}" +"%Y-%m-%d %H:%M:%S %Z"
}

# for scm
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
	psvar=()
	LANG=C vcs_info
	[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="$RPROMPT_DEFAULT %1(v|%F{green}%1v%f|)"

# for direnv
if builtin command -v direnv > /dev/null ; then
    eval "$(direnv hook zsh)"
fi

# local設定の読み込み
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
