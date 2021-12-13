function mkcd() {
  mkdir -p $1
  cd $1
}

function find-in() {
  __is_cmd ggrep && local cmd=ggrep || local cmd=grep
  find $1 -type d -name .git -prune -o -type f -print | xargs $cmd ${@:2:($#-1)}
}
