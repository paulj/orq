require 'rake'
require 'spec/rake/spectask'

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
	t.spec_opts  = ["-cfs"]
	t.spec_files = FileList['spec/**/*_spec.rb']
	t.libs = ['lib', 'spec/support']
end

desc "Print specdocs"
Spec::Rake::SpecTask.new(:doc) do |t|
	t.spec_opts = ["--format", "specdoc", "--dry-run"]
	t.spec_files = FileList['spec/*_spec.rb']
end

desc "Generate RCov code coverage report"
Spec::Rake::SpecTask.new('rcov') do |t|
	t.spec_files = FileList['spec/*_spec.rb']
	t.rcov = true
	t.rcov_opts = ['--exclude', 'examples']
end

task :default => :spec

######################################################

require 'rake'
require 'rake/testtask'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'fileutils'
include FileUtils
# $:.push File.join(File.dirname(__FILE__), 'lib')

version = '0.0.1'
name = "orq"

spec = Gem::Specification.new do |s|
	s.name = name
	s.version = version
	s.summary = "Ruby Object Relational Queueing."
	s.description = "ORQ is a queueing abstraction layer allowing messaging to be done directly from object."
	s.author = "Paul Jones"
	s.email = "pauljones23@gmail.com"
	s.homepage = "http://github.com/vuderacha/orq/"
	s.executables = []
	s.default_executable = nil
  # s.rubyforge_project = "orq"

	s.platform = Gem::Platform::RUBY
	s.has_rdoc = true
	
	s.files = %w(Rakefile README.rdoc) + Dir.glob("{bin,lib,spec}/**/*")
	
	s.require_path = "lib"
	s.bindir = "bin"
	
	s.add_dependency('activesupport', '>= 2.2.2')
end

Rake::GemPackageTask.new(spec) do |p|
	p.need_tar = true if RUBY_PLATFORM !~ /mswin/
end

desc "Updates the Gemspec for ORQ"
task "orq.gemspec" do |t|
  require 'yaml'
  open(t.name, "w") { |f| f.puts spec.to_yaml }
end

task :install => [ :test, :package ] do
	sh %{sudo gem install pkg/#{name}-#{version}.gem}
end

task :uninstall => [ :clean ] do
	sh %{sudo gem uninstall #{name}}
end

task :test => [ :spec ]

Rake::RDocTask.new do |t|
	t.rdoc_dir = 'rdoc'
	t.title    = "ORQ -- Object Relational Queueing"
	t.options << '--line-numbers' << '--inline-source' << '-A cattr_accessor=object'
	t.options << '--charset' << 'utf-8'
	t.rdoc_files.include('README.rdoc')
	t.rdoc_files.include('lib/orq/*.rb')
end

CLEAN.include [ 'build/*', '**/*.o', '**/*.so', '**/*.a', 'lib/*-*', '**/*.log', 'pkg', 'lib/*.bundle', '*.gem', '.config' ]

