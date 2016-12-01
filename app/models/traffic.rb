class Traffic < ApplicationRecord

  response = HTTParty.get("https://api.tfl.gov.uk/Road/all/Street/Disruption?startDate=2016-12-01&endDate=2016-12-31")
  
  # JSON.parse parses response.body into a ruby object.
  JSON.parse(response.body)

end
