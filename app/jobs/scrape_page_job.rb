class ScrapePageJob < ApplicationJob
  queue_as :default
  include Wombat::Crawler

  def perform
    puts "scrape the page"
    browser = Watir::Browser.new :phantomjs
    browser.goto "https://www.eprice.it/black-hour"
    sleep 3
    data = Nokogiri::HTML(browser.html)
    prices = data.css('.itemPrice').text
    prices.gsub('€', '').split(' ').each do |p|
      puts p
    end
  end
end
