# Rakefile for wtsnjp/dotfiles.
require 'pathname'

# constants
HOME = Pathname.new(ENV["HOME"])
REPO_ROOT = Pathname.pwd

# judge platform
def os
  @os ||= (
    host_os = RbConfig::CONFIG['host_os']
    case host_os
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      :windows
    when /darwin|mac os/
      :macos
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      raise "unknown os: #{host_os.inspect}"
    end
  )
end

# the dotfiles map { String => Pathname }
## common
dotfiles_map = {
  "gemrc" => HOME / ".gemrc",
  "gitignore.global" => HOME / ".gitignore.global",
  "vimrc" => HOME / ".vimrc",
  "zshrc" => HOME / ".zshrc",
  "zsh/functions/utility.zsh" => HOME / ".zsh/functions/utility.zsh",
}

## macOS
if os == :macos
  # macOS specific features
  dotfiles_map["zsh/functions/macos.zsh"] = HOME / ".zsh/functions/macos.zsh"
  dotfiles_map["gitconfig.macos"] = HOME / ".gitconfig"

  # blog management
  dotfiles_map["zsh/functions/blog.zsh"] = HOME / ".zsh/functions/blog.zsh"
  dotfiles_map["zsh/completions/_blog"] = HOME / ".zsh/completions/_blog"
else
  dotfiles_map["gitconfig"] = HOME / ".gitconfig"
end

## TeX Live
if system("which kpsewhich > #{File::NULL} 2> #{File::NULL}")
  # zsh functions for TeX
  dotfiles_map["zsh/functions/tex.zsh"] = HOME / ".zsh/functions/tex.zsh"
  dotfiles_map["zsh/functions/ltxpkg-install.zsh"] = HOME / ".zsh/functions/ltxpkg-install.zsh"

  dotfiles_map["zsh/completions/_kpse"] = HOME / ".zsh/completions/_kpse"

  # TEXMF trees
  TEXMFHOME = Pathname.new(`kpsewhich --var-value TEXMFHOME`.chomp)

  # texmf.cnf
  # NOTE: don't forget to make symlink:
  #   TEXMFLOCAL/web2c/texmf.cnf -> TEXMFHOME/web2c/texmf.cnf
  dotfiles_map["texmf/texmf.cnf"] = TEXMFHOME / "web2c/texmf.cnf"

  # texdoc.cnf
  dotfiles_map["texmf/texdoc.cnf"] = TEXMFHOME / "texdoc/texdoc.cnf"
end

## finalize
dotfiles_map = dotfiles_map.sort.to_h

# files that used to be managed in dotifles
legacies = {
  "latexmkrc" => HOME / ".latexmkrc",
  "zsh/completions/_texdoc" => HOME / ".zsh/completions/_texdoc",
  "zsh/completions/_tlmgr" => HOME / ".zsh/completions/_tlmgr",
}.sort.to_h

# tasks
desc "Show the list of the symlinks"
task :list do
  dotfiles_map.merge(legacies).each do |s, t|
    src = REPO_ROOT / s
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
      ln_s REPO_ROOT / s, t, verbose: false
      puts "Link #{t}"
    rescue Errno::EEXIST
      puts "File #{t} already exist; passing."
    end
  end
end

desc "Remove all symlinks to this repository"
task :unlink do
  dotfiles_map.merge(legacies).each do |s, t|
    src = REPO_ROOT / s
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
