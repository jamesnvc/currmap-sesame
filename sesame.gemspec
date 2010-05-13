# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sesame}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Cash"]
  s.date = %q{2010-05-13}
  s.description = %q{Establish an object-database mapping to an OpenRDF Sesame Triple Store database}
  s.email = %q{james.cash@occasionallycogent.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/sesame.rb"]
  s.files = ["README.rdoc", "Rakefile", "lib/sesame.rb", "sesame-tests.rb", "Manifest", "sesame.gemspec"]
  s.homepage = %q{http://github.com/jamesnvc/sesame}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Sesame", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sesame}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Establish an object-database mapping to an OpenRDF Sesame Triple Store database}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
