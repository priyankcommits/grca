class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  class Archive
    @queue = :file_serve

    def self.perform(msg)
      puts "Archiving"
      puts msg
    end
  end
end
