module Api
  module V1
    class WeatherController < ApplicationController
      def current
        data = Score.last
        
        render json: { action: "Current temperature", data: data }, status: 200
      end

      def historical
        render json: { action: "Historical temperature by 24 hours by Metrical", data: daily_scores }, status: 200
      end

      def max
        score_max = Score.where(id: daily_scores.pluck(:id)).order(value: :desc).first
        
        render json: { action: "Maximum temperature by 24 hours", temperature_max: score_max }, status: 200
      end

      def min
        score_min = Score.where(id: daily_scores.pluck(:id)).order(value: :asc).first
        
        render json: { action: "Minimum temperature by 24 hours", temperature_min: score_min }, status: 200
      end

      def avg
        data = daily_scores.pluck(:value)
        count = data.count
        avg_temperature = data.sum / count

        render json: { action: "Temperature average by 24 hours", avg_temperature: avg_temperature.round(1) }, status: 200
      end

      def by_time
        data = Score.find_by(timestamp: params[:selected_time])
        
        if data
          render json: { action: "Temperature by time", temperature: data }, status: 200
        else
          render json: { message: "Temperature by selected time not found" }, status: 404
        end
      end

      private

      def daily_scores
        Score.last(24)
      end
    end
  end
end
