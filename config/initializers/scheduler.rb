require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

include BiographiesHelper

s.cron('00 01 * * Sun') do
  Rails.logger.info "#{Time.now}: Featured biographies reset"
  reset_featured_bios
end
