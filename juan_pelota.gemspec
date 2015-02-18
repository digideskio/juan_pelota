# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'juan_pelota/version'

Gem::Specification.new do |spec|
  spec.name          = 'juan_pelota'
  spec.version       = JuanPelota::VERSION
  spec.authors       = ['thekompanee', 'goodscout']
  spec.email         = 'scoutsquad@goodscout.io'
  spec.summary       = %q{Log Sidekiq messages in JSON format}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/goodscout/juan_pelota"
  spec.license       = 'MIT'

  spec.executables   = Dir['{bin}/**/*'].map    {|dir| dir.gsub!(/\Abin\//, '')}.
                                         reject {|bin| %w{rails rspec rake setup deploy}}
  spec.files         = Dir['{app,config,db,lib}/**/*'] + %w{Rakefile README.md LICENSE}
  spec.test_files    = Dir['{test,spec,features}/**/*']

  spec.add_runtime_dependency     'sidekiq',                    ["~> 3.0"]

  spec.add_development_dependency 'rspec',                      ["~> 3.1"]
  spec.add_development_dependency 'rspectacular',               ["~> 0.58.0"]
  spec.add_development_dependency 'fuubar',                     ["~> 2.0"]
end
