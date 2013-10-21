Gem::Specification.new do |spec|
  spec.name          = "ruby-promise"
  spec.version       = '0.0.1'
  spec.authors       = ["Bachue Zhou"]
  spec.email         = ["bachue.shu@gmail.com"]
  spec.description   = <<-DESC
A gem implement AngularJS Promises in Ruby

AngularJS Promise introduction: http://urish.org/angular/AngularPromises.pdf
  DESC
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "GPLv3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
