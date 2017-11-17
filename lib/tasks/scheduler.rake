task scrape_page: :environment do
  puts "Start creating job task"
  ScrapePageJob.perform_now
  puts "Done creating job task"
end
