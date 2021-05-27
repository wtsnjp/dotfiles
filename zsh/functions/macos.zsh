# Watson's zsh functions for macOS
# Author: wtsnjp
# Website: https://wtsnjp.com
# Source: https://github.com/wtsnjp/dotfiles

# warn and abort reading if not macOS
if [[ ! $OSTYPE = darwin* ]]; then
  echo "WARNING: Script $0 only works on macOS!"
  return
fi

# environment variables
export HOMEBREW_INSTALL_CLEANUP=1

## wifi [on|off]
# toggle wifi
function wifi() { networksetup -setairportpower en0 $1 }

## um
# unmount all external disks
function um() {
  local cond="(every disk whose ejectable is true)"
  local script="tell application \"Finder\" to eject $cond"
  osascript -e "$script" && __relax && osascript -e "$script"
}

## upup
# the daily routine
function upup() {
  __exec_cmd brew update && __relax
  __exec_cmd brew upgrade && __relax
}

## check-git-status
# show uncommited repositories
function check-git-status() {
  local original_dir=$(pwd)

  # TARGET is first argument or current dir
  local TARGET="$1"
  : ${TARGET:="$original_dir"}

  # check each repo
  for dir in $(find $(greadlink -f $TARGET) -maxdepth 1 -type d); do
    if [[ -d "$dir/.git" ]]; then
      cd "$dir"
      local git_status=$(git status 2> /dev/null)
      if [[ ! -n $(echo "$git_status" | grep "^nothing to") ]]; then
        echo "$dir"
      fi
    fi
  done

  # back to PWD
  cd "$original_dir"
}
