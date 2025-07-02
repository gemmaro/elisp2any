require 'bundler/gem_tasks'
require "open3"

task :deploy do
  out, _stat = Open3.capture2("./bin/dev")
  File.write("/tmp/index.html", out)
  sh "rsync", "-av", "/tmp/index.html", "pi:/srv/www/emacs/"
end
