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

## ksrc <file>
# open the source <file> in texmf scope with vim
function ksrc() {
  local keyword
  if echo $1 | fgrep -q '.'; then
    keyword="$1"
  else
    keyword="$1.sty"
  fi
  local target="$(kpsewhich $keyword)"
  if [ -n "$target" ]; then
    vim "$target"
  else
    echo "Source file \"$keyword\" does not exist!"
    return 1
  fi
}

## kdoc <file>
# open the documentation <file> in texmf scope with vim
function kdoc() {
  local keyword
  if echo $1 | fgrep -q '.'; then
    keyword="$1"
  else
    keyword="$1.tex"
  fi
  local target="$(kpsewhich --format=doc $keyword)"
  if [ -n "$target" ]; then
    vim "$target"
  else
    echo "Documentation \"$keyword\" does not exist!"
    return 1
  fi
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
