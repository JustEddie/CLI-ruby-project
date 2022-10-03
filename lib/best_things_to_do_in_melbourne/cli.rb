require_relative '../../config/environment'
require_relative '../best_things_to_do_in_melbourne'

class BestThingsToDoInMelbourne::CLI
  def call
    BestThingsToDoInMelbourne::Scraper.new.make_things_to_do
    puts "Best Things To Do In Melbourne"
  end
  binding.pry
end
