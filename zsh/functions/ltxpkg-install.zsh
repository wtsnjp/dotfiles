#
# This is file 'ltxpkg-install.zsh'.
#
# Copyright (c) 2018 Takuto ASAKURA (wtsnjp)
#   GitHub:   https://github.com/wtsnjp
#   Twitter:  @wtsnjp
#
# This package is distributed under the MIT License.
#

function ltxpkg-install() {
  # general variables
  local PWD=$(pwd)
  local PKG_NAME=$(basename $PWD)
  local TEXMFHOME=$(kpsewhich -var-value=TEXMFHOME)

  # install targets
  local RUN_DIR=${TEXMFHOME}/tex/latex/${PKG_NAME}
  local DOC_DIR=${TEXMFHOME}/doc/latex/${PKG_NAME}

  # local functions
  local function mkdir-p() {
    echo mkdir -p $1
    mkdir -p $1
  }
  local function ln-s() {
    if [ ! -e $2 ]; then
      echo ln -s $1 $2
      ln -s $1 $2
    fi
  }

  # install runs
  local runs=(
    {,lib/,cls/}*.cls(.N)
    {,lib/,sty/}*.sty(.N)
    {,lib/,def/}*.def(.N)
    {,lib/,fd/}*.fd(.N)
  )

  if [ $#runs -gt 0 ]; then
    mkdir-p $RUN_DIR
    for r in $runs; do
      ln-s ${PWD}/${r} ${RUN_DIR}/$(basename $r)
    done
  fi

  # install docs
  local docs=(
    README(.N)
    LICENSE(.N)
    {,doc/,sample/}*.txt(.N)
    {,doc/,sample/}*.md(.N)
    {,doc/,sample/}*.pdf(.N)
  )

  if [ $#docs -gt 0 ]; then
    mkdir-p $DOC_DIR
    for d in $docs; do
      ln-s ${PWD}/${d} ${DOC_DIR}/$(basename $d)
    done
  fi
}
