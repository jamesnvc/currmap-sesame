require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('sesame', '0.1.0') do |p|
  p.description = "Establish an object-database mapping to an OpenRDF Sesame Triple Store database"
  p.url = "http://github.com/jamesnvc/sesame"
  p.author = "James Cash"
  p.email = "james.cash@occasionallycogent.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
