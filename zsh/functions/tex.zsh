# Watson's zsh functions related to TeX
# Author: wtsnjp
# Website: https://wtsnjp.com
# Source: https://github.com/wtsnjp/dotfiles

## texsw (only for main macOS)
function __texsw_init() {
  local tl_dir="/usr/local/texlive"
  local dev_tl_dir="$HOME/repos/tug.org/texlive/Master"

  # check the main tl dir
  if [ ! -d $tl_dir ]; then
    return 1
  fi

  # search texlives
  typeset -g -A texsw_texlives
  for tl in $(find "$tl_dir" -maxdepth 1 -type d \
    | grep -e "$tl_dir/\d\d\d\d"); do
    texsw_texlives[$(basename $tl)]="$tl"
  done

  # get global texlive
  if [ -h "$HOME/.tlbin" ]; then
    export TEXSW_GLOBAL_TEXLIVE=$(readlink $HOME/.tlbin \
      | gsed -r 's@(.*)/bin/(x86_64|universal)-darwin@\1@')
  fi

  # default: global texlive or the latest texlive
  if [ -v TEXSW_GLOBAL_TEXLIVE ]; then
    export TEXSW_CURRENT_TEXLIVE=$TEXSW_GLOBAL_TEXLIVE
  else
    export TEXSW_CURRENT_TEXLIVE=$(echo ${(@O)texsw_texlives} | cut -d' ' -f 1)
  fi

  function __texsw_set_current_bin() {
    # check the bin directory of the suitable architecture name
    if [ -d "$TEXSW_CURRENT_TEXLIVE/bin/x86_64-darwin" ]; then
      export TEXSW_CURRENT_TEXLIVE_BIN="$TEXSW_CURRENT_TEXLIVE/bin/x86_64-darwin"
    elif [ -d "$TEXSW_CURRENT_TEXLIVE/bin/universal-darwin" ]; then
      export TEXSW_CURRENT_TEXLIVE_BIN="$TEXSW_CURRENT_TEXLIVE/bin/universal-darwin"
    else
      echo "texsw: bin dir not found for TeX Live $1."
      return 1
    fi
  }
  __texsw_set_current_bin

  __add_path "$TEXSW_CURRENT_TEXLIVE_BIN" && __uniq_path

  # add dev TL
  if [ -d $dev_tl_dir ]; then
    texsw_texlives[dev]="$dev_tl_dir"
  fi

  # activate internal functions
  __texsw_functions
}

function __texsw_functions() {
  function __texsw_list() {
    local short
    local texsw_status

    for tl_name in ${(ko)texsw_texlives}; do
      local tl_path=$texsw_texlives[$tl_name]
      if [ "$tl_path" = "$TEXSW_CURRENT_TEXLIVE" ]; then
        texsw_status="* "
      else
        texsw_status="  "
      fi
      echo "$texsw_status$tl_name\t($tl_path)"
    done

    echo
    echo "global: $TEXSW_GLOBAL_TEXLIVE"
  }

  function __texsw_switch() {
    local prev_tl

    if [[ -n "${texsw_texlives[(i)$1]}" ]]; then
      prev_tl="$TEXSW_CURRENT_TEXLIVE"
      export TEXSW_CURRENT_TEXLIVE=$texsw_texlives[$1]
      __texsw_set_current_bin
    else
      echo "texsw: TeX Live $1 does not exist."
      return 1
    fi

    # remove previous TL and add new TL to the path
    export PATH=$(echo -n $PATH | tr ':' '\n' | \
      gsed -re "\@$prev_tl/bin/(x86_64-darwin|universal-darwin)@d" | tr '\n' ':')
    __add_path "$TEXSW_CURRENT_TEXLIVE_BIN" && __uniq_path

    # report
    echo "texsw: switch to: $TEXSW_CURRENT_TEXLIVE"
    echo "texsw:      from: $prev_tl"
  }

  function __texsw_global_switch() {
    if __texsw_switch $1; then
      unlink "$HOME/.tlbin"
      ln -s "$TEXSW_CURRENT_TEXLIVE_BIN" "$HOME/.tlbin"
      export TEXSW_GLOBAL_TEXLIVE="$TEXSW_CURRENT_TEXLIVE"
    fi
  }
}

## preparation
if [[ "$OSTYPE" == "darwin"* ]]; then
  if __texsw_init; then
    function texsw() {
      if [ "$1" = "-l" ]; then
        __texsw_list
      elif [ "$1" = "-g" ]; then
        __texsw_global_switch $2
      else
        __texsw_switch $1
      fi
    }
  fi
fi

if ! __is_cmd kpsewhich; then
  # no TL: warn and abort
  echo "WARNING: Script $0 only works with TeX Live!"
  return
fi

## tstex
# create temporaly TeX project and return the generated file path
function tstex() {
  # I prefer to put temporaly files in $HOME/tmp
  local tmp_dir="$HOME/tmp"
  if [ ! -d $tmp_dir ]; then
    echo 'No temporaly directory under your $HOME'
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
  local exts=("" ".dtx" ".sty" ".cls")

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
