class TrafficsController < ApplicationController
  def index
  	start_date = params[:start_date]
    end_date = params[:end_date]
    traffic = Traffic.new(start_date, end_date)
    @coordinates = traffic.coordinates
  end
end
