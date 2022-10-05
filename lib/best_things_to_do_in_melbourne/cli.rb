require_relative '../../config/environment'
require_relative '../best_things_to_do_in_melbourne'

class BestThingsToDoInMelbourne::CLI
  def call
    BestThingsToDoInMelbourne::Scraper.new.make_things_to_do
    system 'clear'
    BestThingsToDoInMelbourne::Logo.draw
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
      puts 'Thank you! See you again!'.blue
      exit
    else
      puts ''
      puts ''
      puts 'Please type y or n!'.red
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
    puts 'Would you like to see more information of any of above? [ number(1-30) / n ]'.blue
    puts ''
    puts ''
    input = gets.strip
    if input.to_i <= 30 && input.to_i.to_s == input
      print_todo(input)
    elsif input === 'n'
      puts ''
      puts ''
      puts 'Thank you! See you again!'.blue
      exit
    elsif input.to_i > 31 || input != 'n'
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
    puts TTY::Link.link_to('See more info', "#{todo.url}").blue
    puts ''
    puts ''
    puts 'Would you like to see other things to do again? [y/n]'.blue

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
