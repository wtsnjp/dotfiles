# 補完機能（gitも補完）
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -U compinit
compinit -u

# プロンプトの設定
autoload colors
colors
PROMPT="
%{${fg[yellow]}%}%~%{${reset_color}%} 
Watson-Mac$ "
PROMPT2='[%n]> ' 

# プロンプトの設定（旧バージョン）
### autoload colors
### colors
### PROMPT="
### %{${fg[yellow]}%}%~%{${reset_color}%} 
### %m$ "
### PROMPT2='[%n]> ' 

# コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# コマンド履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# ディレクトリ名を入力するだけで移動
setopt auto_cd

# 移動したディレクトリを記録しておく。"cd -[Tab]"で移動履歴を一覧
setopt auto_pushd

# コマンド訂正
setopt correct

# 補完候補を詰めて表示する
setopt list_packed 

# ハイライトを有効にする
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# hubコマンドを有効に
eval "$(hub alias -s)"

# エイリアス
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias cot='open -a CotEditor.app'
alias wifi='/usr/sbin/networksetup -setairportpower en0'
alias move='diskutil unmount "/Volumes/Backup HD";diskutil unmount "/Volumes/Data HD"'
alias maxima='exec /Applications/Maxima.app/Contents/Resources/rmaxima.sh'
alias gosh='rlwrap gosh'
alias z_tree='tree -d -L 2 ~/Documents/0-chromosome/'
