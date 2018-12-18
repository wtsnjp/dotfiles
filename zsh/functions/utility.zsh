function mkcd() {
  mkdir -p $1
  cd $1
}

function find-in() {
  find $1 -type f -print | xargs ggrep ${@:2:($#-1)}
}
