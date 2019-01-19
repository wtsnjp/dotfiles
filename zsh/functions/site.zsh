# Watson's zsh functions for managing the site
# Author: wtsnjp
# Website: https://wtsnjp.com
# Source: https://github.com/wtsnjp/dotfiles

# warn and abort reading if not macOS
if [[ ! $OSTYPE = darwin* ]]; then
  echo "WARNING: Script $0 only works on macOS!"
  return
fi

# config
export SITE_PATH="$HOME/repos/wtsnjp.com"

# wrapper
function site() {
  if __is_cmd site-$1; then
    site-$1 "${@:2}"
  else
    echo "site: '$1' is not a site command."
    return 1
  fi
}

# preview the site
function site-preview() {
  cd $SITE_PATH
  open "/Applications/Google Chrome.app" http://localhost:1313
  __exec_cmd hugo server -D -w --disableFastRender
}

# update the site
function site-update() {
  cd $SITE_PATH
  __exec_cmd hugo

  cd $SITE_PATH/public
  __exec_cmd git add -A
  __exec_cmd git commit -m "\"only update\""
  __exec_cmd git push origin master

  cd $SITE_PATH
}
