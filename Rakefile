# Rakefile for wtsnjp/dotfiles.
require 'os'
require 'pathname'

# constants
HOME = Pathname.new(ENV["HOME"])
PWD = Pathname.pwd

# the dotfiles map { String => Pathname }
## common
dotfiles_map = {
  "gemrc" => HOME + ".gemrc",
  "gitconfig" => HOME + ".gitconfig",
  "gitignore.global" => HOME + ".gitignore.global",
  "latexmkrc" => HOME + ".latexmkrc",
  "vimrc" => HOME + ".vimrc",
  "zshrc" => HOME + ".zshrc",
  "zsh/completions/_texdoc" => HOME + ".zsh/completions/_texdoc",
  "zsh/functions/hugo.zsh" => HOME + ".zsh/functions/hugo.zsh",
  "zsh/functions/ltxpkg-install.zsh" => HOME + ".zsh/functions/ltxpkg-install.zsh",
  "zsh/functions/utility.zsh" => HOME + ".zsh/functions/utility.zsh",
}

## macOS
if OS.mac?
  dotfiles_map["zsh/functions/macos.zsh"] = HOME + ".zsh/functions/macos.zsh"
end

## TeX Live
if system("which kpsewhich > #{File::NULL} 2> #{File::NULL}")
  # TEXMF trees
  TEXMFHOME = Pathname.new(`kpsewhich --var-value TEXMFHOME`.chomp)

  # texmf.cnf
  # NOTE: don't forget to make symlink:
  #   TEXMFLOCAL/web2c/texmf.cnf -> TEXMFHOME/web2c/texmf.cnf
  dotfiles_map["texmf/texmf.cnf"] = TEXMFHOME + "web2c/texmf.cnf"

  # texdoc.cnf
  dotfiles_map["texmf/texdoc.cnf"] = TEXMFHOME + "texdoc/texdoc.cnf"
end

## finalize
dotfiles_map = dotfiles_map.sort.to_h

# tasks
desc "Show the list of the symlinks"
task :list do
  dotfiles_map.each do |s, t|
    src = PWD + s
    if t.symlink? and t.readlink == src
      puts "#{t} -> #{src}"
    end
  end
end

desc "Put symlinks to setup my configurations"
task :link do
  dotfiles_map.each do |s, t|
    # preparation
    mkdir_p t.parent, verbose: false

    # create a symlink
    begin
      ln_s PWD + s, t, verbose: false
      puts "Link #{t}"
    rescue Errno::EEXIST
      puts "File #{t} already exist; passing."
    end
  end
end

desc "Remove all symlinks to this repository"
task :unlink do
  dotfiles_map.each do |s, t|
    src = PWD + s
    if t.symlink? and t.readlink == src
      rm_f t, verbose: false
      puts "Remove #{t}"
    end
  end
end

desc "Update cvimrc on gist"
task :update_cvimrc do
  gist_url = "https://gist.github.com/wtsnjp/dd9459a3b0a105cc66440daaeba85126"
  sh "gist -u #{gist_url} cvimrc"
end
