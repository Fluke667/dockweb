#!/bin/sh
git clone --depth=1 https://github.com/Bash-it/bash-it.git /tmp/bash-it

cat > /etc/.bashrc <<-EOF
# Enable programmable completion features.
if [ -f "/etc/.history" ]; then
source /etc/.history
fi
if [ -f "/etc/.path" ]; then
source /etc/.path 
fi
if [ -f "/etc/.aliases" ]; then
source /etc/.aliases
fi
if [ -f "/etc/.functions" ]; then
source /etc/.functions
fi
if [ -f "/etc/.completion" ]; then
source /etc/.completion
fi
if [ -f "/etc/.profile" ]; then
source /etc/.profile
fi
if [ -f "/etc/.themes" ]; then
source /etc/.themes
fi
if [ -f "/etc/.prompt" ]; then
source /etc/.prompt
fi
if [ -f "/etc/.gitconfig" ]; then
source /etc/.gitconfig
fi
if [ -f "/etc/.inputrc" ]; then
source /etc/.inputrc
fi
if [ -f "/etc/.wgetrc" ]; then
source /etc/.wgetrc
fi
if [ -f "/etc/.plugins" ]; then
source /etc/.plugins
fi
if [ -f "/etc/.themes" ]; then
source /etc/.themes
fi
if [ -f "/etc/.nanorc" ]; then
source /etc/.nanorc
fi
if [ -f "/etc/.sshconf" ]; then
source /etc/.sshconf
fi

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# colour Definitions for .bashrc
COL_YEL="\[\e[1;33m\]"
COL_GRA="\[\e[0;37m\]"
COL_WHI="\[\e[1;37m\]"
COL_GRE="\[\e[1;32m\]"
COL_RED="\[\e[1;31m\]"
COL_BLU="\[\e[1;34m\]"

# Bash Prompt
if test "$UID" -eq 0 ; then
	_COL_USER=$COL_RED
	_p=" #"
else
	_COL_USER=$COL_GRE
	_p=">"
fi

# Bash Prompt
if test "$UID" -eq 0 ; then
	_COL_USER=$COL_RED
	_p=" #"
else
	_COL_USER=$COL_GRE
	_p=">"
fi

COLORIZED_PROMPT="${_COL_USER}\u${COL_WHI}@${COL_YEL}\h${COL_WHI}:${COL_BLU}\w${_p}\[\e[m\]"

case $TERM in
	*term | rxvt | screen )
		PS1="${COLORIZED_PROMPT}\$(parse_git_branch)\$ " ;;
	linux )
		PS1="${COLORIZED_PROMPT}" ;;
	* )
		PS1="\u@\h:\w${_p} " ;;
esac
EOF


cat > /etc/.completion <<-EOF
# Enable programmable completion features.
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi
EOF



cat > /etc/.profile <<-EOF
#export CHARSET=UTF-8
#export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#export PAGER=less
export PS1='\h:\w\$ '
umask 022

for script in /etc/profile.d/*.sh ; do
        if [ -r $script ] ; then
                . $script
        fi
done


function extract()    # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

EOF


cat > /etc/.aliases <<-EOF
# Make some possibly destructive commands more interactive.
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Add some easy shortcuts for formatted directory listings and add a touch of color.
alias ll='ls -lF --color=auto'
alias la='ls -alF --color=auto'
alias ls='ls -F'

# Better mkdir  
alias mkdir='mkdir -pv'
    
# Color grep
alias grep='grep -in'

alias python='python3'
alias pip='pip3'

## pass options to free ##
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##

EOF

cat>/etc/.nanorc <<-EOF
set constantshow
set linenumbers
set brackets ""')>]}"
set historylog
set morespace
unset nowrap
set regexp
set smarthome
set suspend
set tabsize 4
set tabstospaces
EOF

cat>/etc/.theme <<-EOF
# Load theme, if a theme was set  
if [[ ! -z "${BASH_THEME}" ]]; then  
  # shellcheck source=./themes/colors.theme.bash
  source "/etc/bash/themes/${BASH_THEME}/${BASH_THEME}.theme.bash"
  EOF


        echo    
	echo -e "${INFO} Manage Tools init process done. Ready for init Bash." 
	echo
  
  "$@"

