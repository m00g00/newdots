
#zstyle ':prezto:environment:termcap' color

if [[ -z "$TMUX" && $(tput colors) == 256 ]]; then
    #export TERM='xterm-256color'
	#prompt nicoulaj
else
	#prompt walters
fi 
export TERM=st-256color
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd completealiases sharehistory promptsubst autopushd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/moogoo/.zshrc'

autoload -Uz compinit promptinit colors
colors
compinit
promptinit
#prompt bart
# End of lines added by compinstall

zstyle ':completion:*' menu select


alias ls='ls --color=auto'
#alias pacman='sudo pacman'
#alias packer='sudo packer'
#alias pack='sudo packer --noconfirm --noedit -S' 

#autoload -U promptinit
#promptinit


export LESS_TERMCAP_md=$'\E[1;34m'
#export http_proxy=http://localhost:8123/

#alias fg='fgz'

set_title() {
    print -Pn "\e]0;$(print -n $@ | tr -d "\\n")\a"
    [[ $TERM = screen* ]] && print -Pn "\033k$(print -n $@ | tr -d "\\n")\033\\"
}

fg() {
    local sstr
    local findsym="^\[[[:digit:]]\][[:space:]]*"
    if [[ "$@" == "%" || "$@" == "%%" || "$@" == "%+" || -z "$@" ]]; then
        sstr="${findsym}\+"
    elif [[ "$@" == "%-" ]]; then
        sstr="${findsym}-"
    elif [[ "$1" == "%"* ]]; then
        local ss="${1[2,-1]}"
        if [[ "$ss" = <-> ]]; then
            sstr="^\[$ss\]"
        elif [[ "${ss[1,1]}" == "?" ]]; then
            sstr="${findsym}[ +-][[:space:]]*suspended[[:space:]]\+.*${ss[2,-1]}"
        else
            sstr="${findsym}[ +-][[:space:]]*suspended[[:space:]]\+$ss"
        fi
    else
        sstr="$@"
    fi

    #echo $sstr

    local cmd="$(jobs | grep "$sstr" | cut -d' ' -f 6-)" 
    set_title $cmd
    builtin fg $@ 2>/dev/null
    [[ $? -ne 0 ]] && echo "fg: $@: no such job"
}


case $TERM in
	*xterm*|*screen*|*rxvt*|*st-256color)
		precmd () { 
			print -Pn "\e]0;%~\a"
			print -Pn "\033k%~\033\\"
		}
		preexec () { 
			#a=$1
			#a=$( print -Pn $a | tr -d "\n" )
			#print -Pn "\e]0;$a\a"
            if [[ $1 != fg* ]]; then
                set_title $1
            fi

			#print -Pn "\e]0;$(print -n $cmd | tr -d "\\n")\a"
			#[[ $TERM = screen* ]] && print -Pn "\033k$(print -n $cmd | tr -d "\\n")\033\\"
		}

		zle-line-init zle-keymap-select () {
			case $KEYMAP in
				vicmd) print -n '\e]12;#00ff00\a' ;;
				main) print -n '\e]12;#bfbfbf\a' ;;
			esac
		}

		zle -N zle-keymap-select
		zle -N zle-line-init

		;;
esac

zstyle ":completion:*:commands" rehash 1

bindkey '^?' backward-delete-char
bindkey '^R' history-incremental-search-backward
bindkey '^N' push-line

bcolor () {
	echo %{$fg_bold[$1]%}${@:2}%{$reset_color%}
}

scolor () {
	echo %{$fg[$1]%}${@:2}%{$reset_color%}
}

spwd () {
	
	#get full pwd, replace home with ~
	p=${$(pwd)/$HOME/\~}
	
	#if in any dir cept ~, do stuff
	if [ $p != \~ ]; then

		#if in dir not originating from ~, add leading /
		[[ $p[1] != \~ && $p != / ]] && echo -n $(bcolor green /)

		#split path and echo first char + /
		for i in ${(s:/:)$(dirname $p)}; do 
			echo -n $(scolor green $i[0,${1:-${#i}}])$(bcolor green /)
		done
	fi
	
	#echo full string of last part
	echo $(scolor green $(basename $p))
}

PROMPT='%{%(!.$fg[red].$fg[green])%}$(spwd)%{$fg_bold[green]%}>%{$reset_color%} '
#RPROMPT="%{$fg_bold[black]%}%*%{$reset_color%}"
# vi: set ts=4 sw=4:
export NVM_DIR="/home/moogoo/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
