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

## kpse [-d] <file>
# open <file> in texmf scope with vim
function kpse() {
  if [ "$1" = "-d" ]; then
    __kpse_doc $2
  else
    __kpse_src $1
  fi
}

## __kpse_src <file>
function __kpse_src() {
  local target
  local exts=("" ".dtx" ".sty")

  for ext in "$exts[@]"; do
    target=$(kpsewhich "$1$ext")

    if [ -n "$target" ]; then
      vim "$target"
      return 0
    fi
  done

  echo "Source for \"$1\" does not exist!"
  return 1
}

## __kpse_doc <file>
function __kpse_doc() {
  local target
  local exts=("" ".tex")

  for ext in "$exts[@]"; do
    target=$(kpsewhich --format=doc "$1$ext")

    if [ -n "$target" ]; then
      vim "$target"
      return 0
    fi
  done

  echo "Documentation for \"$1\" does not exist!"
  return 1
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
