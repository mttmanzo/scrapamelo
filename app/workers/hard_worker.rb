require 'sidekiq-scheduler'
class HardWorker
  include Sidekiq::Worker
  include Wombat::Crawler
  require 'twilio-ruby'

  def perform(*args)
    logger.info "Scraping the page..."
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
        logger.info "C'è roba bona!"
        price_found = true
      end
    end

    if price_found
      send_mail()
      make_calls()
    end
  end

  def send_mail
    logger.info "Sending mail notices"
    #ApplicationMailer.send_notices().deliver_now
  end

  def make_calls

  end


end
