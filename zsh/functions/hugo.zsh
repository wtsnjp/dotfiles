# Functions for Hugo

export BLOG_PATH=~/repos/blog.wtsnjp.com

function blog-new() {
  cd $BLOG_PATH
  hugo new post/$1.md --editor="macdown"
}

function blog-preview() {
  cd $BLOG_PATH
  open "/Applications/Google Chrome.app" http://localhost:1313
  hugo server -D -w --disableFastRender
}

function blog-publish() {
  cd $BLOG_PATH
  blog-undraft content/post/$1.md
  hugo
  cd $BLOG_PATH/public
  git add -A && git commit -m "publish $1"
  git push origin gh-pages
  cd $BLOG_PATH
}

function blog-undraft() {
  local ctime=$(gdate --iso-8601=seconds)
  sed -i "" -e "1,10 s/^date = .*$/date = \"$ctime\"/" $1
  sed -i "" -e "1,10 s/^draft = .*$/draft = false/" $1
}

function blog-update() {
  cd $BLOG_PATH
  hugo
  cd $BLOG_PATH/public
  git add -A && git commit -m "only update"
  git push origin gh-pages
  cd $BLOG_PATH
}
