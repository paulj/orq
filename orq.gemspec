# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{orq}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Jones"]
  s.date = %q{2009-03-25}
  s.description = %q{ORQ is a queueing abstraction layer allowing messaging to be done directly from object.}
  s.email = %q{pauljones23@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["Rakefile", "README.rdoc", "lib/orq", "lib/orq/adapters", "lib/orq/adapters/amqp_adapter.rb", "lib/orq/impulse.rb", "spec/impulse_spec.rb", "spec/simple_config.yml", "spec/stub_config.yml", "spec/support", "spec/support/orq", "spec/support/orq/adapters", "spec/support/orq/adapters/stub_adapter.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/vuderacha/orq/}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby Object Relational Queueing.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.2.2"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.2.2"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.2.2"])
  end
end
