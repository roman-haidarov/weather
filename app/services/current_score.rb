class CurrentScore
  def self.call
    data = requested_data.first
    score = Score.find_by(timestamp: data["EpochTime"].to_s)
    unless score
      score = Score.create!(
        timestamp: data["EpochTime"].to_s,
        unit: data["Temperature"]["Metric"]["Unit"],
        value: data["Temperature"]["Metric"]["Value"].to_f.round(2)
      )
    end

    score
  end

  private

  def self.requested_data  
    if Rails.env == "development" || Rails.env == "production"
      requested_response = rest_client_request('http://dataservice.accuweather.com/currentconditions/v1/329260')
      JSON.parse(requested_response)
    elsif Rails.env == "test"
      file = File.open("#{Rails.root}/spec/support/test_data_current.json")
      JSON.load(file)
    end
  end

  def self.rest_client_request(url)
    RestClient.get "#{url}?apikey=#{Rails.application.credentials.api_key}"
  end
end