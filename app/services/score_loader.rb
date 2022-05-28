class ScoreLoader
  def self.call
    requested_data.each do |element|
      finded_score = Score.find_by(timestamp: element["EpochTime"].to_s)

      unless finded_score
        Score.create!(
          timestamp: element["EpochTime"].to_s,
          unit: element["Temperature"]["Metric"]["Unit"],
          value: element["Temperature"]["Metric"]["Value"].to_f.round(2)
        )
      end
    end
  end

  private

  def self.requested_data  
    if Rails.env == "development" || Rails.env == "production"
      requested_response = rest_client_request('http://dataservice.accuweather.com/currentconditions/v1/329260/historical/24')
      JSON.parse(requested_response)
    elsif Rails.env == "test"
      file = File.open("#{Rails.root}/spec/support/test_data.json")
      JSON.load(file)
    end
  end

  def self.rest_client_request(url)
    RestClient.get "#{url}?apikey=#{Rails.application.credentials.api_key}"
  end
end
