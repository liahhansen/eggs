task :cron => :environment do
  # runs every hour

  # back up at 3am
  if Time.now.hour == 3
    Rake::Task['heroku:backup'].invoke
  end

  Rake::Task['reminders:deliver'].invoke

end

namespace :reminders do
  desc "Check for and deliver pending reminders"
  task :deliver => :environment do
    begin
      pending_reminders = DeliveryOrderReminder.count
      puts "checking for pending reminders: #{pending_reminders} pending"

      ReminderManager.new.deliver_ready_reminders if (pending_reminders >=1)

      puts "done: #{pending_reminders - DeliveryOrderReminder.count} sent."
    end
  end
end