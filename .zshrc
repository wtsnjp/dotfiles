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
PROMPT2='[%n]> ' 

#---------------------------
# History settings
#---------------------------

# Dir and its size
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

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

# Run cd with path
setopt auto_cd

# Remember move history (show list with "cd -[Tab]")
setopt auto_pushd

# Correct command
setopt correct

# Show alternate list compact
setopt list_packed 

# Enable highlight
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Enable hub
eval "$(hub alias -s)"

# Define aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

case ${OSTYPE} in
  darwin*)
    alias cot='open -a CotEditor.app'
    alias wifi='/usr/sbin/networksetup -setairportpower en0'
    alias move='diskutil unmount "/Volumes/Backup HD";diskutil unmount "/Volumes/Data HD"'
    alias maxima='exec /Applications/Maxima.app/Contents/Resources/rmaxima.sh'
    alias gosh='rlwrap gosh'
    alias z_tree='tree -d -L 2 ~/Documents/0-chromosome/'
esac

