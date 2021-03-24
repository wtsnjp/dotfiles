# Watson's zshrc
# Author: wtsnjp
# Website: https://wtsnjp.com
# Source: https://github.com/wtsnjp/dotfiles

#---------------------------
# Startup
#---------------------------

# load system-wide settings
[ -x /usr/libexec/path_helper ] && eval "$(/usr/libexec/path_helper -s)"

# make sure to put /usr/local to PATH
path=(/usr/local/bin /usr/local/sbin $path)

# environment variables
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#---------------------------
# Utility
#---------------------------

## __is_cmd <command>
# if <command> exists, return true
function __is_cmd() { which $1 >/dev/null 2>&1 }

## __add_path <path>
# add <path> if the dir exists
function __add_path() { [ -d $1 ] && path=($1 $path) }

## __uniq_path
# finalize the path
function __uniq_path() {
  # the $HOME/bin has the highest priority
  __add_path "$HOME/bin"

  # delete overlapped paths
  typeset -U path
}

## __shortcut <alias> <command>
# make a shortcut <alias> if the <command> exist
function __shortcut() { __is_cmd $2 && alias $1="$2" }

## __relax
# do nothing for a moment
function __relax() { sleep 0.5 }

## __exec_cmd <command> [<arg> ...]
# eval <command> with a message
function __exec_cmd() { echo "* $@" && eval "$@" }

## __exec_file <file>
# exec <file> if it exists
function __exec_file() { [ -f "$1" ] && source "$1" }

#---------------------------
# Zplug
#---------------------------

# install
if [ ! -d "$HOME/.zplug" ]; then
  curl -sL --proto-redir -all,https\
    https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# initialize
source "$HOME/.zplug/init.zsh" > /dev/null 2>&1

# list of plugins
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# load plugins
zplug load

# install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo
    zplug install
  fi
fi

#---------------------------
# Completion
#---------------------------

# load local completion functions
fpath=($HOME/.zsh/completions $fpath)

# travis (gem)
__exec_file "$HOME/.travis/travis.sh"

# enable completion
autoload -U compinit
compinit -u

# do not suggest current dir
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*' ignore-parents parent pwd ..

#---------------------------
# fzf
#---------------------------

if __is_cmd fzf; then
  __exec_file "$HOME/.fzf.zsh"
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
  export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
fi

#---------------------------
# Prompt settings
#---------------------------

if [ -z "$MACHINE" ]; then
  export MACHINE="$(hostname)"
fi

function __left_prompt {
  # colors
  local name_t='179m%}'    # user name text clolr
  local name_b='000m%}'    # user name background color
  local path_t='255m%}'    # path text clolr
  local path_b='031m%}'    # path background color
  local arrow='087m%}'     # arrow color
  local text_color='%{\e[38;5;'    # set text color
  local back_color='%{\e[30;48;5;' # set background color
  local reset='%{\e[0m%}'  # reset
  local sharp='\uE0B0'     # triangle

  # build
  local user_color="${back_color}${name_b}${text_color}${name_t}"
  local dir_color="${back_color}${path_b}${text_color}${path_t}"

  local first="${user_color}wtsnjp@${MACHINE}${back_color}${path_b}${text_color}${name_b}${sharp}"
  local second="${dir_color}%~${reset}${text_color}${path_b}${sharp}${reset}"
  local third="${text_color}${arrow}\$ ${reset}"
  echo "\n${first} ${second}\n${third}"
}

function __right_prompt {
  local branch='\ue0a0'
  local color='%{\e[38;5;'
  local green='114m%}'
  local red='001m%}'
  local yellow='227m%}'
  local blue='033m%}'
  local reset='%{\e[0m%}'

  # do nothing unless in a git repository
  if [[ ! -d  "$PWD/.git" ]]; then
    return
  fi

  local branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  local git_status=$(git status 2> /dev/null)

  local branch_status
  if [[ -n `echo "$git_status" | grep "^nothing to"` ]]; then
    # green if clean (everything is commited)
    branch_status="${color}${green}${branch}"
  elif [[ -n `echo "$git_status" | grep "^Untracked files"` ]]; then
    # red if untracked files exist
    branch_status="${color}${red}${branch}?"
  elif [[ -n `echo "$git_status" | grep "^Changes not staged for commit"` ]]; then
    # red if unstaged files exist
    branch_status="${color}${red}${branch}+"
  elif [[ -n `echo "$git_status" | grep "^Changes to be committed"` ]]; then
    # yellow if uncommited files exit
    branch_status="${color}${yellow}${branch}!"
  elif [[ -n `echo "$git_status" | grep "^rebase in progress"` ]]; then
    # red if conflict exist
    echo "${color}${red}${branch}!(no branch)${reset}"
  else
    branch_status="${color}${blue}${branch}"
  fi
  echo "${branch_status}${branch_name}${reset}"
}

# always update prompt
setopt prompt_subst
export PROMPT=$(__left_prompt)
export RPROMPT='$(__right_prompt)'

#---------------------------
# History settings
#---------------------------

# dir and its size
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# ignore duplication command history list
setopt hist_ignore_dups

# share command history data
setopt share_history

# extend history search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#---------------------------
# Confortable settings
#---------------------------

# run cd with path
setopt auto_cd

# remember move history (show list with "cd -[Tab]")
setopt auto_pushd

# correct command
setopt correct

# show alternate list compact
setopt list_packed

# exec R-lang with r
disable r

#---------------------------
# Optional settings
#---------------------------

# enable hub
__is_cmd hub && eval "$(hub alias -s)"

# initialize rbenv & pyenv
__add_path "$HOME/.rbenv/bin"
__add_path "$HOME/.pyenv/bin"
__is_cmd rbenv && eval "$(rbenv init -)"
__is_cmd pyenv && eval "$(pyenv init -)"

# use binary from cargo
__add_path "$HOME/.cargo/bin"

# save readline histories to $HOME/.rlwrap
__is_cmd rlwrap && export RLWRAP_HOME="$HOME/.rlwrap"

# additional paths
case $OSTYPE in
  darwin*)
    __add_path "/usr/local/opt/gettext/bin"
    ;;
esac

#---------------------------
# Aliases
#---------------------------

# execute with sudo
alias please='sudo $(fc -ln -1)'

# safer rm
if __is_cmd rmtrash; then
  alias rm="rmtrash"
else
  alias rm="rm -i"
fi

# prevent deleting files unintentionally
alias cp="cp -i"
alias mv="mv -i"

# IPython
__shortcut ipy ipython
__shortcut ipy3 ipython3

# aliases depending on OS
case $OSTYPE in
  # Aliases for macOS
  darwin*)
    # ls: colorful output by default
    alias ls="ls -Gh"
    alias gls="gls --color=auto --human-readable"
    ;;
  # aliases for Linux
  linux*)
    # ls: colorful output by default
    alias ls="ls --color=auto --human-readable"
    ;;
esac

#---------------------------
# Finalize
#---------------------------

# load my plugins
() {
  local -a func_src
  func_src=($HOME/.zsh/functions/*.zsh)
  for fs in $func_src; do
    __exec_file "$fs"
  done
}

# tidy up the path
__uniq_path

# delete overlapped paths
typeset -U cdpath fpath manpath

# prevent lines inserted unintentionally
:<< COMMENTOUT
