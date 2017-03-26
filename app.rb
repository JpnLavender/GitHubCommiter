#-- coding: utf-8

require "open-uri"
require "rubygems"
require "nokogiri"
require "curb"
require "json"

class GitHubCommiter
  def initialize
    @url = "https://github.com/JpnLavender"
    @commit_count = []
    @charset = nil
    @data = { 
      channel: "#bot_tech",
      username: "GitHubCommiter",
      icon_url: "http://chicodeza.com/wordpress/wp-content/uploads/kusa-illust11.png",
      text: "まだコミットがされていません"
    }
  end

  def main
    chloring
    judge
  end

  def chloring
    html = open(@url) { |f| @charset = f.charset; f.read }
    doc = Nokogiri::HTML.parse(html, nil, @charset)
    doc.css("rect.day").each do |commit|
      @commit_count << commit.attributes["data-count"].value
    end
  end

  def judge
    unless "0" == @commit_count.last
      puts "Commiting!"
    else
      Curl.post(ENV["SLACK_WEBHOOKS_TOKEN"], @data.to_json)
    end
  end
end

GitHubCommiter.new.main
