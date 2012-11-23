# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["asok"]
  gem.email         = ["adam.sokolnicki@gmail.com"]
  gem.description   = %q{Prints Given/When/Then steps in capybara features}
  gem.summary       = %q{Prints Given/When/Then steps in capybara features}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cardoon"
  gem.require_paths = ["lib"]
  gem.version       = '0.1.0'
end
