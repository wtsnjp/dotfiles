# complete settings (complete git command)
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -U compinit
compinit -u

# prompt settings
autoload colors
colors
PROMPT="
%{${fg[yellow]}%}%~%{${reset_color}%} 
Watson-Mac$ "
PROMPT2='[%n]> ' 

# command history
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# history search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# cd with path
setopt auto_cd

# remember move history (show list with "cd -[Tab]")
setopt auto_pushd

# correct command
setopt correct

# show alternate list compact
setopt list_packed 

# enable highlight
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# enable hub
eval "$(hub alias -s)"

# aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias cot='open -a CotEditor.app'
alias wifi='/usr/sbin/networksetup -setairportpower en0'
alias move='diskutil unmount "/Volumes/Backup HD";diskutil unmount "/Volumes/Data HD"'
alias maxima='exec /Applications/Maxima.app/Contents/Resources/rmaxima.sh'
alias gosh='rlwrap gosh'
alias z_tree='tree -d -L 2 ~/Documents/0-chromosome/'
