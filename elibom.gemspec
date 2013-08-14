Gem::Specification.new do |s|
  s.name        = 'elibom'
  s.version     = '0.5.0'
  s.date        = '2013-08-06'
  s.summary     = "Elibom API client"
  s.description = "A client of the Elibom API"
  s.authors     = [ "German Escobar" ]
  s.email       = 'german.escobar@elibom.com'
  s.files       = ["lib/elibom.rb", "lib/elibom/client.rb"]
  s.homepage    = 'http://rubygems.org/gems/elibom'

  s.add_dependency('json')
end