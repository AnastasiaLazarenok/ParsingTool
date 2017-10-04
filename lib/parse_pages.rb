require "parse_pages/version"
require 'open-uri'
require 'nokogiri'
require 'rss'
require 'koala'

class Parsing

  def self.get_link(url)
    parse = ParsePage.new(url)
    parse.get_link(url)
  end

  class Parsing::ParsePage
    ACCESS_TOKEN = 'EAAbvUIDYcagBAAZAMOXtX7zD4Jcs4wGohZAtGOvRu4W4nMa1o4vmiZBWZCpgZBbqBZCHVYfYtO0wPC9eMEEoZCk1Vs36tjZAHQ7phVR9ZARMTToREmsAEdZBq92xvM4AntS2SwGZAFrSk17h6lZBVGbt3ZAIZBaL1HIrkpACdHZAiqfIsly2UoDaRZBZCcpBl'
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
      @graph = Koala::Facebook::API.new(ACCESS_TOKEN)
      words = ['https://www.facebook.com/','/']
      re = Regexp.union(words)
      aa = url.gsub(re, "")
      
      @graph.get_object(aa)
      p @graph.get_connection(aa, 'posts', {
        limit: 100,
        fields: ['message']
      })   
    end  
  end
end
