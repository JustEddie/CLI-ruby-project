require 'pry'
require 'nokogiri'
require 'open-uri'
require 'tty-link'
require 'colorize'


module BestThingsToDoInMelbourne
  class CLI


    def call
        logo = "
██████╗ ███████╗███████╗████████╗    ████████╗██╗  ██╗██╗███╗   ██╗ ██████╗ ███████╗            
██╔══██╗██╔════╝██╔════╝╚══██╔══╝    ╚══██╔══╝██║  ██║██║████╗  ██║██╔════╝ ██╔════╝            
██████╔╝█████╗  ███████╗   ██║          ██║   ███████║██║██╔██╗ ██║██║  ███╗███████╗            
██╔══██╗██╔══╝  ╚════██║   ██║          ██║   ██╔══██║██║██║╚██╗██║██║   ██║╚════██║            
██████╔╝███████╗███████║   ██║          ██║   ██║  ██║██║██║ ╚████║╚██████╔╝███████║            
╚═════╝ ╚══════╝╚══════╝   ╚═╝          ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝            
████████╗ ██████╗     ██████╗  ██████╗                                                          
╚══██╔══╝██╔═══██╗    ██╔══██╗██╔═══██╗                                                         
   ██║   ██║   ██║    ██║  ██║██║   ██║                                                         
   ██║   ██║   ██║    ██║  ██║██║   ██║                                                         
   ██║   ╚██████╔╝    ██████╔╝╚██████╔╝                                                         
   ╚═╝    ╚═════╝     ╚═════╝  ╚═════╝                                                          
██╗███╗   ██╗    ███╗   ███╗███████╗██╗     ██████╗  ██████╗ ██╗   ██╗██████╗ ███╗   ██╗███████╗
██║████╗  ██║    ████╗ ████║██╔════╝██║     ██╔══██╗██╔═══██╗██║   ██║██╔══██╗████╗  ██║██╔════╝
██║██╔██╗ ██║    ██╔████╔██║█████╗  ██║     ██████╔╝██║   ██║██║   ██║██████╔╝██╔██╗ ██║█████╗  
██║██║╚██╗██║    ██║╚██╔╝██║██╔══╝  ██║     ██╔══██╗██║   ██║██║   ██║██╔══██╗██║╚██╗██║██╔══╝  
██║██║ ╚████║    ██║ ╚═╝ ██║███████╗███████╗██████╔╝╚██████╔╝╚██████╔╝██║  ██║██║ ╚████║███████╗
╚═╝╚═╝  ╚═══╝    ╚═╝     ╚═╝╚══════╝╚══════╝╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝
                                                                                                
"
      Scraper.new.make_things_to_do
      system "clear"
      puts logo.yellow
      start
    end

    def start
      puts 'Would you like to see list of top 30 best things to do in Melbourne? [y/n]'.colorize(:blue)
      input = gets.strip

      if input === 'y'
        print_list
      elsif input === 'n'
        puts ''
        puts ''
        puts 'Thank you! See you again!'
        exit
      else
        puts ''
        puts ''
        puts 'Please type y or n!'
        puts ''
        start
      end
    end

    def print_list
      BestThingsToDoInMelbourne::ToDo.all.each do |todo|
        puts ''
        puts "#{todo.position} #{todo.title}".yellow
      end
      choose
    end

    def choose
      puts ''
      puts ''
      puts 'Would you like to see more information of any of above?'.light_blue
      puts ''
      puts '[ number(1-30) / n ]'.red
      input = gets.strip
      if input.to_i <= 31
        print_todo(input)
      elsif input === 'n'
        puts ''
        puts ''
        puts 'Thank you! See you again!'.light_blue
        exit
      else
        puts ''
        puts ''
        puts 'Please type valid number or n'.red
        choose
      end
    end

    def print_todo(input)
      todo = BestThingsToDoInMelbourne::ToDo.all[input.to_i - 1]
      puts ''
      puts ''
      puts "******* #{todo.title} *******".green
      puts ''
      puts "Category : #{todo.category}".green
      puts ''
      puts "Location : #{todo.location}".green
      puts ''
      puts 'About'.green
      puts "#{todo.about}".green
    #   puts "Open Hours : #{todo.open_hours.empty? ? 'not provided' : todo.open_hours}"
      puts ''
      puts TTY::Link.link_to("See more info", "#{todo.url}").blue
      puts ''
      puts ''
      puts 'Would you like to see other things to do again? [y/n]'.light_blue

      input = gets.strip
      if input === 'y'
        start
      elsif input === 'n'
        puts 'Thank you! See you again!'.light_blue
        exit
      else
        puts 'Type y or n please!'.red
      end
    end
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
    attr_accessor :url, :title, :position, :location, :category, :open_hours, :about

    @@all = []

    def self.new_from_index_page(row)
      new(
        "https://www.tripadvisor.com.au/#{row.css('a').attribute('href').text}",
        row.css('div.XfVdV').text.gsub(/[\d.]/, ''),
        row.css('span.vAUKO').text,
        row.css('div.alPVI.eNNhq.PgLKC.tnGGX.yzLvM div.biGQs._P.pZUbB.hmDzD').text.gsub("Open now","")
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
      @location ||= doc.css('div.MJ button.UikNM span.biGQs._P.XWJSj.Wb').text.gsub('Read more', '')
    end

    # def open_hours
    #   @open_hours ||= doc.css('div.biGQs._P.pZUbB.KxBGd').text.match(/(1[012]|[1-9]):[0-5][0-9](\s)(AM|PM)(\s-\s)(1[012]|[1-9]):[0-5][0-9](\s)(AM|PM)/)[0]
    # end

    def about
      @about ||= doc.css('div.A div._T.FKffI div.biGQs._P.pZUbB.KxBGd').text
    end

    # def website
    #     @website ||= doc.css('section.vwOfI.nlaXM div.WoBiw a.UikNM._G.B-._S._T.c.G_.P0.wSSLS.wnNQG.raEkE').first.attribute('href').text
    # end

    # @website = website
  end
  binding.pry
end

require_relative '../config/environment'
