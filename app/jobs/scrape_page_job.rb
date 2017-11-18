#class ScrapePageJob < ApplicationJob
class ScrapePageJob # avoid inheriting from active job for dj recurring
  # queue_as :default
  include Wombat::Crawler
  require 'twilio-ruby'

  include Delayed::RecurringJob
  run_every 1.minute
  #run_at '11:00am'
  timezone 'US/Pacific'
  queue 'slow-jobs'

  def perform
    logger.info "Scraping the page..."
    price_found = false
    browser = Watir::Browser.new :phantomjs
    browser.goto "https://www.eprice.it/black-hour"
    sleep 3
    data = Nokogiri::HTML(browser.html)
    prices = data.css('.itemPrice').text
    prices.gsub('€', '').split(' ').each do |p|
      # puts p
      # if p == '37,99'
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
    ApplicationMailer.send_notices().deliver_now
  end

  def make_calls
    logger.info "Calling friends by phone"
    account_sid = ENV['TWILIO_ACCOUNT']
    auth_token = ENV['TWILIO_TOKEN']

    @client = Twilio::REST::Client.new account_sid, auth_token

    # silvio
    @client.api.account.calls.create(
      from: ENV['PHONE_CALLER'],
      to: ENV['PHONE1'],
      url: 'https://demo.twilio.com/welcome/voice/'
    )

    # gdmn
    # @client.api.account.calls.create(
    #   from: ENV['PHONE_CALLER'],
    #   to: ENV['PHONE2'],
    #   url: 'https://demo.twilio.com/welcome/voice/'
    # )

    # matte
    # @client.api.account.calls.create(
    #   from: ENV['PHONE_CALLER'],
    #   to: ENV['PHONE3'],
    #   url: 'https://demo.twilio.com/welcome/voice/'
    # )

  end
end
