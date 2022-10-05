class BestThingsToDoInMelbourne::ToDo
  attr_accessor :url, :title, :position, :location, :category, :open_hours, :about

  @@all = []

  def self.new_from_index_page(row)
    new(
      "https://www.tripadvisor.com.au/#{row.css('a').attribute('href').text}",
      row.css('div.XfVdV').text.gsub(/[\d.]/, ''),
      row.css('span.vAUKO').text,
      row.css('div.alPVI.eNNhq.PgLKC.tnGGX.yzLvM div.biGQs._P.pZUbB.hmDzD').text.gsub('Open now', '')
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