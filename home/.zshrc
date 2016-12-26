# Watson's zshrc
# Author: wtsnjp
# Website: https://wtsnjp.com
# Source: https://github.com/wtsnjp/dotfiles

#---------------------------
# Environments
#---------------------------

### Config
export LANG=en_US.UTF-8

### Tools
export PAGER="vimpager"
export RLWRAP_HOME=".rlwrap"

#---------------------------
# Complete settings
#---------------------------

# Enable complete
autoload -U compinit
compinit -u

# Complete git command (macOS only)
case ${OSTYPE} in
  darwin*)
    fpath=(/usr/local/share/zsh-completions $fpath)
esac

# Do not suggest current dir
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*' ignore-parents parent pwd ..

#---------------------------
# Prompt settings
#---------------------------

local PCDIR=$'\n'%F{yello}%~%f$'\n'
local PNAME="Watson-$MACHINE"
PROMPT="$PCDIR$PNAME$ "
PROMPT2="[$PNAME]> "

#---------------------------
# History settings
#---------------------------

# Dir and its size
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Ignore duplication command history list
setopt hist_ignore_dups

# Share command history data
setopt share_history

# Extend history search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#---------------------------
# Confortable settings
#---------------------------

# Run cd with path
setopt auto_cd

# Remember move history (show list with "cd -[Tab]")
setopt auto_pushd

# Correct command
setopt correct

# Show alternate list compact
setopt list_packed 

# Exec R-lang with r
disable r

#---------------------------
# Optional settings
#---------------------------

# Enable highlight
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Enable hub
if type hub > /dev/null 2>&1; then
  eval "$(hub alias -s)"
fi

#---------------------------
# Functions
#---------------------------

local FUNCPATH="$HOME/.zsh/functions"
case ${OSTYPE} in
  # Functions for Mac
  darwin*)
    source "$FUNCPATH/hugo.zsh"
    source "$FUNCPATH/utility.zsh"
    source "$FUNCPATH/cpdf.zsh"
esac

#---------------------------
# Aliases
#---------------------------

# Ask before delete files
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Execute with sudo
alias please='sudo $(fc -ln -1)'

# Hugo
alias preview='hugo server -D -w'

case ${OSTYPE} in
  # Aliases for Mac
  darwin*)
    # Use colorful output by default
    alias ls='ls -Gh'
    alias gls='gls --color=auto --human-readable'
    # Move files to trash with rm command
    alias rm='rmtrash'
    # Launch IPython quickly
    alias ipy='ipython'
    alias ipy3='ipython3'
    # Measure for brew doctor
    alias brew='env PATH=${PATH/$HOME\/\.pyenv\/shims:/} brew'
    # Update and Upgrade brew
    alias upup='brew update && brew upgrade && brew cleanup'
    # Turn on/off network connection with wifi command
    alias wifi='networksetup -setairportpower en0';;
  # Aliases for Linux
  linux*)
    # Use colorful output by default
    alias ls='ls --color=auto --human-readable'
    # Update and Upgrade apt-get
    alias upup='sudo apt-get update && sudo apt-get upgrade && sudo apt-get clean';;
esac

# Delete overlaped path
typeset -U path cdpath fpath manpath
