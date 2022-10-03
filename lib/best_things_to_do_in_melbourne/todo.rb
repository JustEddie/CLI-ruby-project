class BestThingsToDoInMelbourne::ToDo
  attr_accessor :title, :position, :location, :category, :open_hours, :about, :website

  @@all = []

  def self.new_from_index_page(r)
    new(
      r.css('div.XfVdV').text.gsub(/[\d.]/, ''),
      r.css('span.vAUKO').text,
      r.css('div.biGQs').text
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
