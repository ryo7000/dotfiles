autoload -U compinit
compinit;

# cache
zstyle ':completion::complete:*' use-cache 1

# viÊÔ½¸¥â¡¼¥É
bindkey -v

# ¾å²¼¥­¡¼¤ÈCtrl-p, n¤ÇÍúÎò¸¡º÷¡Ê¥«¡¼¥½¥ë¤Ï¹ÔËö¡Ë
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
bindkey '[A' history-beginning-search-backward-end
bindkey '[B' history-beginning-search-forward-end
bindkey '^R' history-incremental-search-backward

# http://d.hatena.ne.jp/cooldaemon/searchdiary?word=*%5Bzsh%5D
# http://hatena.g.hatena.ne.jp/hatenatech/20060517/1147833430

# Ê£¿ô¤Î zsh ¤òÆ±»þ¤Ë»È¤¦»þ¤Ê¤É history ¥Õ¥¡¥¤¥ë¤Ë¾å½ñ¤­¤»¤ºÄÉ²Ã¤¹¤ë
setopt append_history

# »ØÄê¤·¤¿¥³¥Þ¥ó¥ÉÌ¾¤¬¤Ê¤¯¡¢¥Ç¥£¥ì¥¯¥È¥êÌ¾¤È°ìÃ×¤·¤¿¾ì¹ç cd ¤¹¤ë
setopt auto_cd

# Êä´°¸õÊä¤¬Ê£¿ô¤¢¤ë»þ¤Ë¡¢°ìÍ÷É½¼¨¤¹¤ë
setopt auto_list

# Êä´°¥­¡¼¡ÊTab, Ctrl+I) ¤òÏ¢ÂÇ¤¹¤ë¤À¤±¤Ç½ç¤ËÊä´°¸õÊä¤ò¼«Æ°¤ÇÊä´°¤¹¤ë
setopt auto_menu

# ¥«¥Ã¥³¤ÎÂÐ±þ¤Ê¤É¤ò¼«Æ°Åª¤ËÊä´°¤¹¤ë
setopt auto_param_keys

# ¥Ç¥£¥ì¥¯¥È¥êÌ¾¤ÎÊä´°¤ÇËöÈø¤Î / ¤ò¼«Æ°Åª¤ËÉÕ²Ã¤·¡¢¼¡¤ÎÊä´°¤ËÈ÷¤¨¤ë
setopt auto_param_slash

# ¥Ó¡¼¥×²»¤òÌÄ¤é¤µ¤Ê¤¤¤è¤¦¤Ë¤¹¤ë
setopt NO_beep

# {a-c} ¤ò a b c ¤ËÅ¸³«¤¹¤ëµ¡Ç½¤ò»È¤¨¤ë¤è¤¦¤Ë¤¹¤ë
setopt brace_ccl

# ¥³¥Þ¥ó¥É¤Î¥¹¥Ú¥ë¥Á¥§¥Ã¥¯¤ò¤¹¤ë
setopt correct

# =command ¤ò command ¤Î¥Ñ¥¹Ì¾¤ËÅ¸³«¤¹¤ë
setopt equals

# ¥Õ¥¡¥¤¥ëÌ¾¤Ç #, ~, ^ ¤Î 3 Ê¸»ú¤òÀµµ¬É½¸½¤È¤·¤Æ°·¤¦
setopt extended_glob

# Ctrl+S/Ctrl+Q ¤Ë¤è¤ë¥Õ¥í¡¼À©¸æ¤ò»È¤ï¤Ê¤¤¤è¤¦¤Ë¤¹¤ë
setopt no_flow_control
stty -ixon

# Ä¾Á°¤ÈÆ±¤¸¥³¥Þ¥ó¥É¥é¥¤¥ó¤Ï¥Ò¥¹¥È¥ê¤ËÄÉ²Ã¤·¤Ê¤¤
setopt hist_ignore_dups

# ¥³¥Þ¥ó¥É¥é¥¤¥ó¤ÎÀèÆ¬¤¬¥¹¥Ú¡¼¥¹¤Ç»Ï¤Þ¤ë¾ì¹ç¥Ò¥¹¥È¥ê¤ËÄÉ²Ã¤·¤Ê¤¤
setopt hist_ignore_space

# ¥Ò¥¹¥È¥ê¤ò¸Æ¤Ó½Ð¤·¤Æ¤«¤é¼Â¹Ô¤¹¤ë´Ö¤Ë°ìÃ¶ÊÔ½¸¤Ç¤­¤ë¾õÂÖ¤Ë¤Ê¤ë
setopt hist_verify

# ¥·¥§¥ë¤¬½ªÎ»¤·¤Æ¤âÎ¢¥¸¥ç¥Ö¤Ë HUP ¥·¥°¥Ê¥ë¤òÁ÷¤é¤Ê¤¤¤è¤¦¤Ë¤¹¤ë
setopt NO_hup

# ¥³¥Þ¥ó¥É¥é¥¤¥ó¤Ç¤â # °Ê¹ß¤ò¥³¥á¥ó¥È¤È¸«¤Ê¤¹
setopt interactive_comments

# auto_list ¤ÎÊä´°¸õÊä°ìÍ÷¤Ç¡¢ls -F ¤Î¤è¤¦¤Ë¥Õ¥¡¥¤¥ë¤Î¼ïÊÌ¤ò¥Þ¡¼¥¯É½¼¨
setopt list_types

# ÆâÉô¥³¥Þ¥ó¥É jobs ¤Î½ÐÎÏ¤ò¥Ç¥Õ¥©¥ë¥È¤Ç jobs -l ¤Ë¤¹¤ë
setopt long_list_jobs

# ¥³¥Þ¥ó¥É¥é¥¤¥ó¤Î°ú¿ô¤Ç --prefix=/usr ¤Ê¤É¤Î = °Ê¹ß¤Ç¤âÊä´°¤Ç¤­¤ë
setopt magic_equal_subst

# ¥Õ¥¡¥¤¥ëÌ¾¤ÎÅ¸³«¤Ç¥Ç¥£¥ì¥¯¥È¥ê¤Ë¥Þ¥Ã¥Á¤·¤¿¾ì¹çËöÈø¤Ë / ¤òÉÕ²Ã¤¹¤ë
setopt mark_dirs

# ¥Õ¥¡¥¤¥ëÌ¾¤ÎÅ¸³«¤Ç¡¢¼­½ñ½ç¤Ç¤Ï¤Ê¤¯¿ôÃÍÅª¤Ë¥½¡¼¥È¤µ¤ì¤ë¤è¤¦¤Ë¤Ê¤ë
setopt numeric_glob_sort

# 8 ¥Ó¥Ã¥ÈÌÜ¤òÄÌ¤¹¤è¤¦¤Ë¤Ê¤ê¡¢ÆüËÜ¸ì¤Î¥Õ¥¡¥¤¥ëÌ¾¤Ê¤É¤ò¸«¤ì¤ë¤è¤¦¤Ë¤Ê¤ë
setopt print_eightbit

# ¥·¥§¥ë¤Î¥×¥í¥»¥¹¤´¤È¤ËÍúÎò¤ò¶¦Í­
setopt share_history

# history (fc -l) ¥³¥Þ¥ó¥É¤ò¥Ò¥¹¥È¥ê¥ê¥¹¥È¤«¤é¼è¤ê½ü¤¯¡£
setopt hist_no_store

# Ê¸»úÎóËöÈø¤Ë²þ¹Ô¥³¡¼¥É¤¬Ìµ¤¤¾ì¹ç¤Ç¤âÉ½¼¨¤¹¤ë
unsetopt promptcr

#¥³¥Ô¥Ú¤Î»þrprompt¤òÈóÉ½¼¨¤¹¤ë
setopt transient_rprompt

# cd -[tab] ¤Çpushd
setopt autopushd

# ½ÅÊ£¥Ç¥£¥ì¥¯¥È¥ê¤Ïpushd¤·¤Ê¤¤
setopt pushd_ignore_dups

# ÍúÎò¥Õ¥¡¥¤¥ë¤Ë»þ¹ï¤òµ­Ï¿
setopt extended_history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

# promptÀßÄê
# ¿§¤ò»È¤¦
setopt prompt_subst

autoload -U colors; colors
PROMPT='${WINDOW:+"[$WINDOW]"}%{$fg[green]%}%n@%m %#%{$reset_color%} '
RPROMPT='%{$fg[yellow]%}[%~]%{$reset_color%}'

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

export TIMEFMT=$'%J : \n real\t%*Es\n user\t%*Us\n sys \t%*Ss\n cpu \t%P'
export SVN_EDITOR="vim"
export PATH="$HOME/bin:$PATH"

# psql¤Î½ÐÎÏ¥¨¥ó¥³¡¼¥Ç¥£¥ó¥°ÀßÄê
export PGCLIENTENCODING="UTF-8"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# for euc-jp manpage
alias man="man -P \"cat | nkf -w | /usr/bin/less\""

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

alias -g Rdev="RAILS_ENV=development"
alias -g Rtest="RAILS_ENV=test"
alias -g Rpro="RAILS_ENV=production"

alias update_rails_tags="ctags -R --languages=ruby -f rails_tags \
/usr/lib/ruby/gems/1.8/gems/actionmailer-2.0.2 \
/usr/lib/ruby/gems/1.8/gems/actionpack-2.0.2 \
/usr/lib/ruby/gems/1.8/gems/activerecord-2.0.2 \
/usr/lib/ruby/gems/1.8/gems/activeresource-2.0.2 \
/usr/lib/ruby/gems/1.8/gems/activesupport-2.0.2 \
/usr/lib/ruby/gems/1.8/gems/rails-2.0.2"
