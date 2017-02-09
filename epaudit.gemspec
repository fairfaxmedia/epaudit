# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'epaudit/version'

Gem::Specification.new do |spec|
  spec.name          = "epaudit"
  spec.version       = EPAudit::VERSION
  spec.authors       = ["John Slee"]
  spec.email         = ["john.slee@fairfaxmedia.com.au"]

  spec.summary       = %q{Audit HTTP endpoints}
  spec.description   = %q{Audit HTTP endpoints for a variety of issues}
  spec.homepage      = "https://github.com/fairfaxmedia/epaudit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "borderlands", ">= 0.1"
  spec.add_runtime_dependency "activesupport", ">= 4"
  spec.add_runtime_dependency "synthetics", "~> 0.1"
  spec.add_runtime_dependency "aws-sdk", "~> 2"
  spec.add_runtime_dependency "net-dns", "~> 0.8"
  spec.add_runtime_dependency "thor", ">= 0.19"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
