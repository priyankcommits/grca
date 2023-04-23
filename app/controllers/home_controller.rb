require_relative '../jobs/guests_cleanup_job.rb'

class HomeController < ApplicationController
  def index
  end

  def about
    msg = {:token => "wegeg", :courseId => "wgwg"}
    GuestsCleanupJob.perform_later msg
    render :json => msg
  end
end
