function upup() {
  function relax() { sleep 0.1 }
  function my_brew() { echo "* brew $*" && brew $* }
  my_brew update && relax
  my_brew upgrade --cleanup && relax
  unfunction relax my_brew
}

function um() {
  osascript -e \
    'tell application "Finder" to eject (every disk whose ejectable is true)'
}

function tex-test() {
  cd ~/tmp
  local today=$(date "+%Y%m%d")
  local test_dir=$(mktemp -d test-${today}XXXXX)
  local test_file=$test_dir.tex
  cd $test_dir
  : > $test_file
  open -a TeXShop.app $test_file
}

function texlua() {
  if [ "$1" = "" ]; then
    tlurepl
  else
    command texlua $*
  fi
}
