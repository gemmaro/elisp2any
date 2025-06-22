require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

default_tasks = %i[test]

rubocop = true

begin
  require 'rubocop/rake_task'
rescue LoadError
  rubocop = false
end

if rubocop
  RuboCop::RakeTask.new
  default_tasks << :rubocop
end

task default: default_tasks

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  readme = 'README.md'
  rdoc.main = readme
  rdoc.rdoc_files.include(readme, 'lib/**/*.rb')
end

desc 'start API document server'
task :serve_api do
  serve('html')
end

desc 'generate type signatures'
task :sig do
  sh 'typeprof', *Dir['lib/**/*.rb'], 'sig/elisp2any.rbs', '-o', 'sig/elisp2any.gen.rbs'
end

desc 'start HTML fixture server'
task :serve_fixture do
  serve('fixtures/init')
end

def serve(path)
  sh 'ruby', '-run', '-e', 'httpd', path
end
