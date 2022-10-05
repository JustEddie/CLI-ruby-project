Gem::Specification.new do |s|
  s.name = 'best-things-to-do-in-melbourne'
  s.version     = '0.1.0'
  s.summary     = 'CLI app providing 30 best things to do in Melboune'
  s.description = 'This CLI app provides a list of 30 best things to do in Melbourne. The data is scraped from Trip Advisor website.'
  s.authors     = ['JustEddie']
  s.email       = 'skdpwls830@gmail.com'
  s.files       = ['lib/best_things_to_do_in_melbourne/cli.rb',
                   'lib/best_things_to_do_in_melbourne/scraper.rb',
                   'lib/best_things_to_do_in_melbourne/todo.rb',
                   'lib/best_things_to_do_in_melbourne/logo.rb',
                   'config/environment.rb',
                   'bin/best_things_to_do_in_melbourne.rb',
                   'bin/console',
                   'bin/setup',
                   'lib/best_things_to_do_in_melbourne.rb',
                   'gemfile']
  s.homepage =
    'https://github.com/JustEddie/CLI-ruby-project'
  s.license = 'MIT'
end
