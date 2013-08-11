<<<<<<< HEAD
#encoding:utf-8
require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
=======
# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rubygems/package_task'
require 'rdoc/task'
>>>>>>> 550ece36b32db59fc58b5cf8b051c0fd1b7e4d19
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.name = 'bookmark_server'
  s.version = '0.0.1'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
<<<<<<< HEAD
  s.summary = 'A simple bookmark online server'
  s.description = s.summary
  s.author = 'wuhuizuo'
  s.email = 'wuhuizuo@126.com'
=======
  s.summary = 'Your summary here'
  s.description = s.summary
  s.author = ''
  s.email = ''
>>>>>>> 550ece36b32db59fc58b5cf8b051c0fd1b7e4d19
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end

<<<<<<< HEAD
Rake::GemPackageTask.new(spec) do |p|
=======
Gem::PackageTask.new(spec) do |p|
>>>>>>> 550ece36b32db59fc58b5cf8b051c0fd1b7e4d19
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "bookmark_server Docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end
<<<<<<< HEAD
=======

>>>>>>> 550ece36b32db59fc58b5cf8b051c0fd1b7e4d19
