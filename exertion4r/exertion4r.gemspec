require 'rubygems'

spec = Gem::Specification.new do |s|

  s.name = 'exertion4r'
  s.version = "0.0.1"
  s.platform = Gem::Platform::RUBY
  s.summary = "exertion4r is a pure-Ruby library for parsing performance data from various sports monitoring watches"
  s.files = Dir.glob("lib/**/*").delete_if { |item| item.include?(".svn") }
  s.require_path = 'lib'
  
  s.has_rdoc=false

  s.author = "Ben Walding"
  s.email = "bwalding@codehaus.org"
  s.homepage = "http://exertion4r.rubyhaus.org"

end

if $0==__FILE__
  Gem::manage_gems
  Gem::Builder.new(spec).build
end