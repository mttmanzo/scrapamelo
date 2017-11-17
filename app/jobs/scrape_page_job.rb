class ScrapePageJob < ApplicationJob
  queue_as :default
  include Wombat::Crawler

  def perform
    puts "scrape the page"
    price_found = false
    browser = Watir::Browser.new :phantomjs
    browser.goto "https://www.eprice.it/black-hour"
    sleep 3
    data = Nokogiri::HTML(browser.html)
    prices = data.css('.itemPrice').text
    prices.gsub('€', '').split(' ').each do |p|
      puts p
      # if p == '0,99'
      if p == '0,99'
        puts "C'è roba bona!"
        price_found = true
      end
    end

    if price_found
      ApplicationMailer.send_notices().deliver_now
    end
  end
end
