require 'sidekiq-scheduler'
class HardWorker
  include Sidekiq::Worker

  def perform(*args)
    puts "\n\n\naleeee\n\n\n"
  end
end
