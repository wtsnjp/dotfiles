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
  osascript -e \
    'tell application "Finder" to eject (every disk whose ejectable is true)'
}

## upup
# the daily routine
function upup() {
  __exec_cmd brew update && __relax
  __exec_cmd brew upgrade && __relax
}
