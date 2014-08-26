Gem::Specification.new do |s|
  s.name        = 'elibom'
  s.version     = '0.6.1'
  s.date        = '2013-08-26'
  s.summary     = "Elibom API client"
  s.description = "A client of the Elibom API"
  s.authors     = [ "German Escobar", "Carlos Sepulveda"]
  s.email       = ['german.escobar@elibom.com', 'charlesandrew621@gmail.com']
  s.files       = ["lib/elibom.rb", "lib/elibom/client.rb"]
  s.homepage    = 'http://rubygems.org/gems/elibom'

  s.add_dependency('json')
end