require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

default_tasks = %i[test]

task default: default_tasks

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  readme = 'README.md'
  rdoc.main = readme
  rdoc.rdoc_files.include(readme, 'lib/**/*.rb')
end

desc 'generate type signatures'
task :sig do
  sh 'typeprof', *Dir['lib/**/*.rb'], 'sig/elisp2any.rbs', '-o', 'sig/elisp2any.gen.rbs'
end
