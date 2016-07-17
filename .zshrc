# Watson's zshrc
# Author: Watson
# Website: http://watson-lab.com
# Source: https://github.com/WatsonDNA/config-files

#---------------------------
# Complete settings
#---------------------------

# Enable complete
autoload -U compinit
compinit -u

# Complete git command (Mac only)
case ${OSTYPE} in
  darwin*)
    fpath=(/usr/local/share/zsh-completions $fpath)
    fpath=($(brew --prefix)/share/zsh/site-functions $fpath);;
esac

# Do not suggest current dir
zstyle ':completion:*' ignore-parents parent pwd ..

#---------------------------
# Prompt settings
#---------------------------

autoload colors
colors
PROMPT="
%{${fg[yellow]}%}%~%{${reset_color}%} 
Watson-Mac$ "
PROMPT2='[Watson-Mac]> ' 

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
# Aliases
#---------------------------

# Ask before delete files
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

case ${OSTYPE} in
  # Aliases for Mac
  darwin*)
    # Use colorful output by default
    alias ls='ls -Gh'
    alias gls='gls --color=auto --human-readable'
    # Move files to trash with rm command
    alias rm='rmtrash'
    # Read man with vim
    alias man="man $* -P \"col -b | vim -Rc 'setl ft=man ts=8 nomod' -c 'nn q :q<CR>' -\""
    # Measure for brew doctor
    alias brew="env PATH=${PATH/$HOME\/\.pyenv\/shims:/} brew"
    # Turn on/off network connection with wifi command
    alias wifi='networksetup -setairportpower en0';;
  # Aliases for Linux
  linux*)
    # Use colorful output by default
    alias ls='ls --color=auto --human-readable';;
esac

