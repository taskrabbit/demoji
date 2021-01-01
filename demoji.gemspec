# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'demoji/version'

Gem::Specification.new do |spec|
  spec.name          = "demoji"
  spec.version       = Demoji::VERSION
  spec.authors       = ["David Jairala"]
  spec.email         = ["davidjairala@gmail.com"]
  spec.description   = %q{Replace emojis as to not blow up utf8 MySQL}
  spec.summary       = %q{MySQL configured with utf-8 encoding blows up when trying to save text rows containing emojis, etc., to address this, Demoji rescues from that specific exception and replaces the culprit chars with empty spaces. This is a workaround until Rails adds support for UTF8MB4 in migrations, schema, etc.}
  spec.homepage      = "https://github.com/taskrabbit/demoji"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "appraisal"
end
