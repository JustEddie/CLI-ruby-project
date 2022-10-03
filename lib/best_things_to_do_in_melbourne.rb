module BestThingsToDoInMelbourne
    class CLI
        def call
          Scraper.new.make_things_to_do
          puts "Best Things To Do In Melbourne"
        end
        # binding.pry
      end
      class Scraper
        def get_page
          page = Nokogiri::HTML(open('https://www.tripadvisor.com.au/Attractions-g255100-Activities-a_allAttractions.true-Melbourne_Victoria.html'))
        end
      
        def scrape_to_do_index
          get_page.css('div.hZuqH')
        end
      
        def make_things_to_do
          scrape_to_do_index.each do |r|
            ToDo.new_from_index_page(r)
          end
      
        end
      
        # binding.pry
      end
      class BestThingsToDoInMelbourne::ToDo
        attr_accessor :title, :position, :location, :category, :open_hours, :about, :website
      
        @@all = []
      
        def self.new_from_index_page(row)
          new(
            row.css('div.XfVdV').text.gsub(/[\d.]/, ''),
            row.css('span.vAUKO').text,
            row.css('div.biGQs').text
          )
        end
      
        def initialize(title = nil, position = nil, category = nil)
          @title = title
          @position = position
          @category = category
          @@all << self
        end
      
        # @location = location
        # @open_hours = open_hours
        # @about = about
        # @website = website
      end
end

require_relative '../config/environment'