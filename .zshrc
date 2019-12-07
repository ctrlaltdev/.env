echo ""
dd if=/dev/urandom bs=24 count=1 2> /dev/null | xxd -u -p
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

bindkey "^[[1;5C" forward-word  
bindkey "^[[1;5D" backward-word

# export LANG=en_US.UTF-8

if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

export EDITOR='nvim'

setopt PROMPT_SUBST
# VCS in prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'M' 
zstyle ':vcs_info:*' unstagedstr 'M' 
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
  ' %F{5}[%F{2}%b%F{5}] %F{2}%c%F{3}%u%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git 
+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
  [[ $(git ls-files --other --directory --exclude-standard | sed q | wc -l | tr -d ' ') == 1 ]] ; then
  hook_com[unstaged]+='%F{1}??%f'
fi
}

precmd () { vcs_info }

PROMPT='%F{cyan}%n%f${vcs_info_msg_0_} %F{magenta}~ %f'
RPROMPT='%F{yellow}%~%f'

export PATH=$PATH:$HOME/.local/bin

git_laser () {
    hash="%C(yellow)%h%C(reset)"
    who="%C(white)%an%C(reset)"
    when="%C(white)%ar%C(reset)"
    refs="%C(blue)%d%C(reset)"
    what="%s%C(reset)"
    format="$hash $refs $what $who $when"
    git log --graph --color --abbrev-commit --date=relative --pretty="tformat:${format}" $* | sed -Ee 's/(seconds?|minutes?|hours?|days?|weeks?|months?|years?) ago/\1/' | sed -Ee 's/(years?), [[:digit:]]+ .*months?/\1/' | less -FXRS
}

eval $(thefuck --alias)
