require 'rails_helper'

RSpec.describe CurrentScore do
  subject { described_class }

  it "return curren temperature" do
    expect(subject.call.timestamp).to eq "1653751020"
  end
end