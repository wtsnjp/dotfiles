# Watson's zsh functions related to TeX
# Author: wtsnjp
# Website: https://wtsnjp.com
# Source: https://github.com/wtsnjp/dotfiles

# warn and abort reading if TeX Live isn't installed
if ! __is_cmd kpsewhich; then
  echo "WARNING: Script $0 only works with TeX Live!"
  return
fi

## tstex
# create temporaly TeX project and return the generated file path
function tstex() {
  # I prefer to put temporaly files in $HOME/tmp
  local tmp_dir="$HOME/tmp"
  if [ ! -d $tmp_dir ]; then
    echo 'No temporaly directry under your $HOME'
    return 1
  fi

  # create the test dir
  local test_dir=$(mktemp -d "${tmp_dir}/test-$(date '+%Y%m%d')XXXXX")

  # create the file and echo (only if succeeded)
  local test_file="${test_dir}/$(basename ${test_dir}).tex"
  : > ${test_file} && echo ${test_file}
}

## kpse <file>
# open the <file> in texmf scope with vim
function kpse() {
  local target
  if echo $1 | fgrep -q '.'; then
    target="$1"
  else
    target="$1.sty"
  fi
  vim "$(kpsewhich $target)"
}

## texlua [<arg> ...]
# wrap function for texlua (enable the repl)
function texlua() {
  if __is_cmd tlurepl && [ "$1" = "" ]; then
    command tlurepl
  else
    command texlua "$@"
  fi
}
