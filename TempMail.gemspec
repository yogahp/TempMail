# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tempmail/version'

Gem::Specification.new do |spec|
  spec.name          = 'tempmail'
  spec.version       = TempMail::VERSION
  spec.authors       = [' Yoga Hapriana']
  spec.email         = ['thenelse@rocketmail.com']
  spec.summary       = %q{Client to temp-mail.org API.}
  spec.description   = %q{Ruby client to temp-mail.org API}
  spec.homepage      = 'https://github.com/yogahp/TempMail'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'gmail', '~> 0.6.0'
  spec.add_development_dependency 'net-ping', '~> 1.7.8'
  spec.add_development_dependency 'sendpulse', '~> 0.0.1'
  spec.add_development_dependency 'dotenv', '~> 2.1.1'
end
