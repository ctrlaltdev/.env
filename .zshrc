echo ""
echo "██╗███╗   ██╗██╗████████╗██╗ █████╗ ██╗     ██╗███████╗██╗███╗   ██╗ ██████╗      ██████╗ ██████╗ ██████╗ ███████╗"
echo "██║████╗  ██║██║╚══██╔══╝██║██╔══██╗██║     ██║╚══███╔╝██║████╗  ██║██╔════╝     ██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo "██║██╔██╗ ██║██║   ██║   ██║███████║██║     ██║  ███╔╝ ██║██╔██╗ ██║██║  ███╗    ██║     ██║   ██║██████╔╝█████╗  "
echo "██║██║╚██╗██║██║   ██║   ██║██╔══██║██║     ██║ ███╔╝  ██║██║╚██╗██║██║   ██║    ██║     ██║   ██║██╔══██╗██╔══╝  "
echo "██║██║ ╚████║██║   ██║   ██║██║  ██║███████╗██║███████╗██║██║ ╚████║╚██████╔╝    ╚██████╗╚██████╔╝██║  ██║███████╗"
echo "╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo ""

fortune
echo ""

export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git z sudo vscode yarn)

source $ZSH/oh-my-zsh.sh

# export LANG=en_US.UTF-8

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

export EDITOR='nvim'

setopt PROMPT_SUBST
PROMPT='%F{cyan}%n %F{magenta}~ %f'
RPROMPT='%F{yellow}%~%f'

export PATH=$PATH:$HOME/.local/bin

eval $(thefuck --alias)
