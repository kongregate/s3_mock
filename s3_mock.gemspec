# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3_mock/version'

Gem::Specification.new do |spec|
  spec.name          = "s3_mock"
  spec.version       = S3Mock::VERSION
  spec.authors       = ["Darcy Brown"]
  spec.email         = ["darcy@dbcodeproject.com"]
  spec.summary       = "Quick and dirty mocking for S3"
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'minitest', '5.3.0'
  # spec.add_development_dependency 'mocha', '1.0.0'
  spec.add_runtime_dependency 'mocha', '1.0.0'
  spec.add_runtime_dependency "aws-sdk", "~> 1.51.0"
end
