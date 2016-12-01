class Traffic < ApplicationRecord

	include HTTParty
  base_uri "https://api.tfl.gov.uk/Road/all/Street/Disruption?"
  format :json

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def get_request
  	response = self.class.get("startDate=#{@start_date}&endDate=#{@end_date}")
  
  	# JSON.parse parses response.body into a ruby object.
  	JSON.parse(response.body)
	end

	# Access json object startLat with JsonPath => latitude
  def lat
    JsonPath.on(get_request, '$..startLat')
  end


  # Access json object startLon with JsonPath => longitude
  def lng
    JsonPath.on(get_request, '$..startLon')
  end

  def coordinates
  	# group lat array with corresponding elements of lng array
    coordinates = lat.zip(lng)
    # delete coordinates if include nil or 0.0 values
    coordinates.delete_if{|arr| arr.include?(nil) or arr.include?("0.0")}
    coordinates
  end

end
