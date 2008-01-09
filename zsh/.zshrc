autoload -U compinit promptinit
compinit;
promptinit;

# cache
zstyle ':completion::complete:*' use-cache 1

# vi�Խ��⡼��
bindkey -v
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^R' history-incremental-search-backward

# http://d.hatena.ne.jp/cooldaemon/searchdiary?word=*%5Bzsh%5D
# http://hatena.g.hatena.ne.jp/hatenatech/20060517/1147833430

# ʣ���� zsh ��Ʊ���˻Ȥ����ʤ� history �ե�����˾�񤭤����ɲä���
setopt append_history

# ���ꤷ�����ޥ��̾���ʤ����ǥ��쥯�ȥ�̾�Ȱ��פ������ cd ����
setopt auto_cd

# �䴰���䤬ʣ��������ˡ�����ɽ������
setopt auto_list

# �䴰������Tab, Ctrl+I) ��Ϣ�Ǥ�������ǽ���䴰�����ư���䴰����
setopt auto_menu

# ���å����б��ʤɤ�ưŪ���䴰����
setopt auto_param_keys

# �ǥ��쥯�ȥ�̾���䴰�������� / ��ưŪ���ղä��������䴰��������
setopt auto_param_slash

# �ӡ��ײ����Ĥ餵�ʤ��褦�ˤ���
setopt NO_beep

# {a-c} �� a b c ��Ÿ�����뵡ǽ��Ȥ���褦�ˤ���
setopt brace_ccl

# ���ޥ�ɤΥ��ڥ�����å��򤹤�
setopt correct

# =command �� command �Υѥ�̾��Ÿ������
setopt equals

# �ե�����̾�� #, ~, ^ �� 3 ʸ��������ɽ���Ȥ��ư���
setopt extended_glob

# Ctrl+S/Ctrl+Q �ˤ��ե������Ȥ�ʤ��褦�ˤ���
setopt no_flow_control
stty -ixon

# ľ����Ʊ�����ޥ�ɥ饤��ϥҥ��ȥ���ɲä��ʤ�
setopt hist_ignore_dups

# ���ޥ�ɥ饤�����Ƭ�����ڡ����ǻϤޤ���ҥ��ȥ���ɲä��ʤ�
setopt hist_ignore_space

# �ҥ��ȥ��ƤӽФ��Ƥ���¹Ԥ���֤˰�ö�Խ��Ǥ�����֤ˤʤ�
setopt hist_verify

# �����뤬��λ���Ƥ�΢����֤� HUP �����ʥ������ʤ��褦�ˤ���
setopt NO_hup

# ���ޥ�ɥ饤��Ǥ� # �ʹߤ򥳥��Ȥȸ��ʤ�
setopt interactive_comments

# auto_list ���䴰��������ǡ�ls -F �Τ褦�˥ե�����μ��̤�ޡ���ɽ��
setopt list_types

# �������ޥ�� jobs �ν��Ϥ�ǥե���Ȥ� jobs -l �ˤ���
setopt long_list_jobs

# ���ޥ�ɥ饤��ΰ����� --prefix=/usr �ʤɤ� = �ʹߤǤ��䴰�Ǥ���
setopt magic_equal_subst

# �ե�����̾��Ÿ���ǥǥ��쥯�ȥ�˥ޥå�������������� / ���ղä���
setopt mark_dirs

# �ե�����̾��Ÿ���ǡ������ǤϤʤ�����Ū�˥����Ȥ����褦�ˤʤ�
setopt numeric_glob_sort

# 8 �ӥå��ܤ��̤��褦�ˤʤꡢ���ܸ�Υե�����̾�ʤɤ򸫤��褦�ˤʤ�
setopt print_eightbit

# ������Υץ������Ȥ������ͭ
setopt share_history

# history (fc -l) ���ޥ�ɤ�ҥ��ȥ�ꥹ�Ȥ����������
setopt hist_no_store

# ʸ���������˲��ԥ����ɤ�̵�����Ǥ�ɽ������
unsetopt promptcr

#���ԥڤλ�rprompt����ɽ������
setopt transient_rprompt

# cd -[tab] ��pushd
setopt autopushd

# ��ʣ�ǥ��쥯�ȥ��pushd���ʤ�
setopt pushd_ignore_dups

# ����ե�����˻����Ͽ
setopt extended_history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

# prompt����
# ����Ȥ�
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

# psql�ν��ϥ��󥳡��ǥ�������
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
