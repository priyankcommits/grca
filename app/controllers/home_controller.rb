class HomeController < ApplicationController
  def index
  end

  def about
    msg = {:token => "wegeg", :courseId => "wgwg"}
    # resque job create
    Resque.enqueue(Archive, msg)
    render :json => msg
  end
end
