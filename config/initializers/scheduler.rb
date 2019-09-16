require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

include BiographiesHelper

s.cron('00 01 * * Sun') do
  Rails.logger.info "#{Time.now}: Featured biographies reset"
  reset_featured_bios
end

s.cron('00 05 * * Sun') do
  if Rails.env.production?
    Rails.logger.info "#{Time.now}: Audit links and email report"
    links_report
  end
end
