# require_relative '../../config/environment'
# require_relative '../best_things_to_do_in_melbourne'

class BestThingsToDoInMelbourne::Scraper
  def get_page
    page = Nokogiri::HTML(open('https://www.tripadvisor.com.au/Attractions-g255100-Activities-a_allAttractions.true-Melbourne_Victoria.html'))
  end

  def scrape_to_do_index
    get_page.css('div.hZuqH')
  end

  def make_things_to_do
    scrape_to_do_index.each do |r|
      BestThingsToDoInMelbourne::ToDo.new_from_index_page(r)
    end

  end

  # binding.pry
end
