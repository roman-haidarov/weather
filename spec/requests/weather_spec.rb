require 'rails_helper'

RSpec.describe Api::V1::WeatherController, type: :request do
  describe "GET /current" do
    let!(:score) { create :score, value: 5 }

    before do
      get "/api/v1/weather/current"
    end

    it "return status ok" do
      expect(last_response.status).to eq 200  
    end

    it "return expected data" do
      expect(json['action']).to eq "Current temperature"
      expect(json['data']['value']).to eq 14.3
    end
  end

  describe "GET /historical" do
    let!(:scores) { create_list :score, 24 }

    before do
      get "/api/v1/weather/historical"
    end

    it "return status ok" do
      expect(last_response.status).to eq 200  
    end

    it "return expected data" do
      expect(json['action']).to eq "Historical temperature by 24 hours by Metrical"
      expect(json['data'].pluck('id').sort).to eq scores.pluck(:id).sort
    end
  end

  describe "GET /historical/max" do
    let!(:scores) { create_list :score, 22, value: 3 }
    let!(:score_max) { create :score, value: 20 }
    let!(:score_min) { create :score, value: 1 }

    before do
      get "/api/v1/weather/historical/max"
    end

    it "return status ok" do
      expect(last_response.status).to eq 200  
    end

    it "return expected temperature_max" do
      expect(json['action']).to eq "Maximum temperature by 24 hours"
      expect(json['temperature_max']['id']).to eq score_max.id
    end
  end

  describe "GET /historical/min" do
    let!(:scores) { create_list :score, 22, value: 3 }
    let!(:score_max) { create :score, value: 20 }
    let!(:score_min) { create :score, value: 1 }

    before do
      get "/api/v1/weather/historical/min"
    end

    it "return status ok" do
      expect(last_response.status).to eq 200  
    end

    it "return expected temperature_min" do
      expect(json['action']).to eq "Minimum temperature by 24 hours"
      expect(json['temperature_min']['id']).to eq score_min.id
    end
  end

  describe "GET /historical/avg" do
    let!(:scores) { create_list :score, 23, value: 10 }
    let!(:another_score) { create :score, value: 21 }

    before do
      get "/api/v1/weather/historical/avg"
    end

    it "return status ok" do
      expect(last_response.status).to eq 200  
    end

    it "return expected avg_temperature" do
      expect(json['action']).to eq "Temperature average by 24 hours"
      expect(json['avg_temperature']).to eq 10.5
    end
  end

  describe "GET /by_time" do
    let!(:score) { create :score }

    before do
      get "/api/v1/weather/by_time", { selected_time: selected_time }
    end

    context "when score is exist" do
      let(:selected_time) { score.timestamp }
  
      it "return status ok" do
        expect(last_response.status).to eq 200  
      end
  
      it "return temperature by time" do
        expect(json['action']).to eq "Temperature by time"
        expect(json['temperature']['id']).to eq score.id
      end
    end

    context "when score not exist" do
      let(:selected_time) { "165372108x" }
  
      it "return status not found" do
        expect(last_response.status).to eq 404  
      end
  
      it "return error message" do
        expect(json['message']).to eq "Temperature by selected time not found"
      end
    end
  end
end