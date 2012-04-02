# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pipewise.rb"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Watts"]
  s.date = "2012-04-02"
  s.description = "    pipewise.rb is a gem which allows you to send user and event data \n    to Pipewise via HTTP. It utilizes the same HTTP API endpoints as \n    the Pipewise JavaScript API.\n"
  s.email = "jeff.watts@pipewise.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "lib/pipewise.rb",
    "lib/pipewise/errors.rb",
    "lib/pipewise/version.rb",
    "pipewise.rb.gemspec",
    "spec/fixtures/vcr_cassettes/invalid_api_key_for_event.yml",
    "spec/fixtures/vcr_cassettes/invalid_api_key_for_user.yml",
    "spec/fixtures/vcr_cassettes/invalid_email_for_event.yml",
    "spec/fixtures/vcr_cassettes/invalid_email_for_user.yml",
    "spec/fixtures/vcr_cassettes/nil_event_type.yml",
    "spec/fixtures/vcr_cassettes/valid_arguments_for_user.yml",
    "spec/fixtures/vcr_cassettes/valid_email_for_user.yml",
    "spec/pipewise_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/joinwire/pipewise.rb"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.21"
  s.summary = "A Ruby library for sending user and event data to Pipewise"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8"])
      s.add_development_dependency(%q<vcr>, ["~> 2.0"])
      s.add_development_dependency(%q<fakeweb>, ["~> 1.3"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1.0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<rspec>, ["~> 2.8"])
      s.add_dependency(%q<vcr>, ["~> 2.0"])
      s.add_dependency(%q<fakeweb>, ["~> 1.3"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.1.0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<rspec>, ["~> 2.8"])
    s.add_dependency(%q<vcr>, ["~> 2.0"])
    s.add_dependency(%q<fakeweb>, ["~> 1.3"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.1.0"])
  end
end

