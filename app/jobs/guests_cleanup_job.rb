class GuestsCleanupJob < ApplicationJob
  queue_as :urgent

  def perform(*msg)
    sleep 5
    puts "Archiving"
    puts msg
  end
end
