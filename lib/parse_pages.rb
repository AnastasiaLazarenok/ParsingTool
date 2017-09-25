require "parse_pages/version"
require 'open-uri'
require 'nokogiri'
require 'rss'

class Parsing

  def self.get_link(url)
    parse = ParsePage.new(url)
    parse.get_link(url)
  end

  class Parsing::ParsePage

    def initialize(url)
      @url = url
    end

    def get_link(url)
      if @url =~ URI::regexp
        open_url(@url)
      else
        raise
      end
    end
    
    def open_url(url) 
      @news = []
      if @url.include? "www.facebook.com"
        open_fasebook_page(@url)
      else  
        open(@url) do |rss|
          feed = RSS::Parser.parse(rss)
          feed.items.each do |item| 
            @news << item.description
          end
        end
      end
    end

    def open_fasebook_page(url)
      @news = []
      html = open(@url)
      page = Nokogiri::HTML(html)      
      page.css("div._5pbx.userContent").map do |x|
        @news << x.at_css("p").text
      end
    end
  end
end
