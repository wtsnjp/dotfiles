# Watson's zsh functions for managing the blog
# Author: wtsnjp
# Website: https://wtsnjp.com
# Source: https://github.com/wtsnjp/dotfiles

# warn and abort reading if not macOS
if [[ ! $OSTYPE = darwin* ]]; then
  echo "WARNING: Script $0 only works on macOS!"
  return
fi

# config
export BLOG_PATH="$HOME/repos/blog.wtsnjp.com"

# wrapper
function blog() {
  if __is_cmd blog-$1; then
    blog-$1 "${@:2}"
  else
    echo "blog: '$1' is not a blog command."
    return 1
  fi
}

# create a new article
function blog-new() {
  cd $BLOG_PATH
  hugo new post/$1.md --editor="macdown"
}

# preview the blog
function blog-preview() {
  cd $BLOG_PATH
  function __blog_preview_browse() {
    __relax && open "/Applications/Google Chrome.app" http://localhost:1313 \
      2> /dev/null
  }
  setopt local_options no_notify no_monitor
  __blog_preview_browse &
  unfunction __blog_preview_browse
  __exec_cmd hugo server -D -w
}

# publish an article
function blog-publish() {
  cd $BLOG_PATH
  __exec_cmd blog undraft content/post/$1.md
  __exec_cmd hugo

  cd $BLOG_PATH/public
  __exec_cmd git add -A
  __exec_cmd git commit -m "\"publish $1\""
  __exec_cmd git push origin gh-pages

  cd $BLOG_PATH
}

# undraft an article (there used to be a "hugo undraft")
function blog-undraft() {
  local ctime=$(gdate --iso-8601=seconds)
  sed -i "" -e "1,10 s/^date = .*$/date = \"$ctime\"/" $1
  sed -i "" -e "1,10 s/^draft = .*$/draft = false/" $1
}

# update the blog
function blog-update() {
  cd $BLOG_PATH
  local msg="$(git show --oneline | head -n 1)"
  __exec_cmd hugo

  cd $BLOG_PATH/public
  __exec_cmd git add -A
  __exec_cmd git commit -m \"${msg}\"
  __exec_cmd git push origin gh-pages

  cd $BLOG_PATH
}
