# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'md2doc/version'

Gem::Specification.new do |gem|
  gem.name          = "md2doc"
  gem.version       = Md2doc::VERSION
  gem.authors       = ["Rob Westgeest"]
  gem.email         = ["rob@qwan.it"]
  gem.description   = %q{creates pdf documents from markdown documents}
  gem.summary       = %q{creates pdf documents from markdown documents}
  gem.homepage      = "https://github.com/rwestgeest/md2doc"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
