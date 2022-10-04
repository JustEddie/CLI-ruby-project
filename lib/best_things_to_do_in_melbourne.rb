require 'pry'
require 'nokogiri'
require 'open-uri'

module BestThingsToDoInMelbourne
  class CLI
    def call
      Scraper.new.make_things_to_do
      puts 'Best Things To Do In Melbourne'
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
    attr_accessor :url, :title, :position, :location, :category, :open_hours, :about, :website

    @@all = []

    def self.new_from_index_page(row)
      new(
        "https://www.tripadvisor.com.au/#{row.css('a').attribute('href').text}",
        row.css('div.XfVdV').text.gsub(/[\d.]/, ''),
        row.css('span.vAUKO').text,
        row.css('div.biGQs').text
      )
    end

    def initialize(url = nil, title = nil, position = nil, category = nil)
      @url = url
      @title = title
      @position = position
      @category = category
      @@all << self
    end

    def self.all
      @@all
    end

    def doc
      @doc ||= Nokogiri::HTML(open(url))
    end

    def location
        @location ||=doc.css('div.MJ button.UikNM span.biGQs._P.XWJSj.Wb').text.gsub('Read more',"")
    end
    def open_hours
        @open_hours ||= doc.css('div.biGQs._P.pZUbB.KxBGd').text.match(/(1[012]|[1-9]):[0-5][0-9](\s)(AM|PM)(\s-\s)(1[012]|[1-9]):[0-5][0-9](\s)(AM|PM)/)[0]
    end
    def about
        @about ||=doc.css('div.yNgTB.A div._T.FKffI div.biGQs._P.pZUbB.KxBGd').text
    end
    # def website
    # end
    # @location = location
    # @open_hours = open_hours
    # @about = about
    # @website = website
  end
  binding.pry
end

require_relative '../config/environment'
