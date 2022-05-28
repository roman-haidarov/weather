require 'rails_helper'

RSpec.describe ScoreLoader do
  subject { described_class }

  before { subject.call }

  it "must be equal 24" do
    expect(Score.count).to eq 24
  end
end