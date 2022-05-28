class HealthController < ApplicationController
  def index
    ScoreLoader.call
    render json: { message: "Server is running now" }, status: 200
  end
end
