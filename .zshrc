#  ██╗   ██╗ ██████╗ ██╗██████╗ 
#  ██║   ██║██╔═══██╗██║██╔══██╗
#  ██║   ██║██║   ██║██║██║  ██║
#  ╚██╗ ██╔╝██║   ██║██║██║  ██║
#   ╚████╔╝ ╚██████╔╝██║██████╔╝
#    ╚═══╝   ╚═════╝ ╚═╝╚═════╝ 

echo "             _    _ "
echo "   _ _  ___ |_| _| |"
echo "  | | || . || || . |"
echo "   \_/ |___||_||___|"
echo ""

dd if=/dev/urandom bs=24 count=1 2> /dev/null | xxd -u -p

export ZSH="$HOME/.oh-my-zsh"
plugins=(evalcache z git sudo vscode fast-syntax-highlighting) # zsh-autosuggestions zsh-completions zsh-autocomplete
source $ZSH/oh-my-zsh.sh

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it

setopt autocd              # change directory just by typing its name
setopt correct             # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# export LANG=en_US.UTF-8

if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

if [ -f ~/.path ]; then
  source ~/.path
fi

if [ -f ~/.functions ]; then
  source ~/.functions
fi

export EDITOR='nvim'

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a'
  ;;
*)
  ;;
esac

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

new_line_before_prompt=yes

precmd () {
  vcs_info

  # Print the previously configured title
  print -Pnr -- "$TERM_TITLE"

  # Print a new line before the prompt, but only if it is not the first line
  if [ "$new_line_before_prompt" = yes ]; then
    if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
      _NEW_LINE_BEFORE_PROMPT=1
    else
      print ""
    fi
  fi
}

# enable completion features
autoload -Uz compinit
autoload -U +X bashcompinit && bashcompinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# enable auto-suggestions based on the history
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

if [ "$color_prompt" = yes ]; then
  # PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)──}(%B%F{%(#.red.blue)}%n%(#.💀.㉿)%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
  # RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
  PROMPT='%F{cyan}%n%f${vcs_info_msg_0_} %F{magenta}~ %f'
  RPROMPT='%F{yellow}%~%f'
else
  PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt

SAM_CLI_TELEMETRY=0

# To Support GPG
export GPG_TTY=`tty`

complete -o nospace -C /usr/local/bin/vault vault

if command -v kubectl 1>/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

if command -v goenv 1>/dev/null 2>&1; then
  _evalcache goenv init -
fi

if command -v rbenv 1>/dev/null 2>&1; then
  _evalcache rbenv init -
fi

if command -v pyenv 1>/dev/null 2>&1; then
  _evalcache pyenv init -
fi

if command -v pyenv-virtualenv-init 1>/dev/null 2>&1; then
  _evalcache pyenv virtualenv-init -
fi

if command -v bw 1>/dev/null 2>&1; then
  _evalcache bw completion --shell zsh
  compdef _bw bw
fi

if command -v thefuck 1>/dev/null 2>&1; then
  _evalcache thefuck --alias
fi
