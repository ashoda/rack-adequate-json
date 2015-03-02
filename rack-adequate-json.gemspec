# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/adequate_json/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-adequate-json"
  spec.version       = Rack::AdequateJson::VERSION
  spec.authors       = ["Ashod Ayanyan"]
  spec.email         = ["aayanyan@gmail.com"]
  spec.summary       = %q{Rack Middleware to reduce size of json payload}
  spec.description   = %q{Rack Middleware to reduce size of json payload - Allows clients consuming json apis to select attributes within payload}
  spec.homepage      = "https://github.com/ashoda/rack-adequate-json"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake" , "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "pry", "~> 0.10"
end
