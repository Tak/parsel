require_relative "lib/parsel/version"

Gem::Specification.new do |spec|
  spec.name = "parsel"
  spec.version = Parsel::VERSION
  spec.authors = ["Levi Bard"]
  spec.email = ["taktaktaktaktaktaktaktaktaktak@gmail.com"]

  spec.summary = "A tiny library for parsing simple commands."
  spec.homepage = "https://github.com/Tak/parsel"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "standard"
  spec.add_development_dependency "rspec"
end
