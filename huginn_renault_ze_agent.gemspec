# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "huginn_renault_ze_agent"
  spec.version       = '0.1.5'
  spec.authors       = ["Adrian Schoenig"]
  spec.email         = ["adrian.schoenig@gmail.com"]

  spec.summary       = %q{Huginn agent that provides battery status of Renault ZE vehicles}

  spec.homepage      = "https://github.com/nighthawk/huginn_renault_ze_agent"

  spec.license       = "MIT"


  spec.files         = Dir['LICENSE.txt', 'lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*.rb'].reject { |f| f[%r{^spec/huginn}] }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "huginn_agent"
end
