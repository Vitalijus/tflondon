class Traffic < ApplicationRecord

	include HTTParty
  base_uri "https://api.tfl.gov.uk/Road/all/Street/Disruption?"
  format :json


  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end


  # Rescue HTTParty instances of StandardError like: Net::OpenTimeout, Net::ReadTimeout
  def handle_timeout
    max_retries = 3
    times_retried = 0
    
    begin
      yield
    rescue Net::OpenTimeout, Net::ReadTimeout, SocketError
    	# After 3 attempts to connect exit script
      if times_retried < max_retries
        times_retried += 1
        puts "Failed to connect, retry #{times_retried}/#{max_retries}"
        retry
      else
        puts "Connection failure."
        exit(1)
      end
    end
  end


  def get_request
  	# For connection failures (e.g. if a URL isn´t found) handle_timeout block raises an 
  	# exception and return message.
    handle_timeout do
    	# self.class.get is a GET request to a URL using HTTParty client.
      response = self.class.get("startDate=#{@start_date}&endDate=#{@end_date}", timeout: 3)

      # response.code return HTTP status code 200, 404 etc.
      case response.code
        when 200
          puts "Standard response for successful HTTP requests => #{response.code}"
        when 404
          puts "Resource could not be found. Subsequent requests by the client are permissible => #{response.code}"
        when 500...600
          puts "Server is aware that it has encountered an error or is otherwise incapable of performing the request => #{response.code}"
      end

      # JSON.parse parses response.body into a ruby object.
      JSON.parse(response.body)
    end
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
