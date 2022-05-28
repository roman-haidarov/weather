FactoryBot.define do
  factory :score, class: Score do
    timestamp { "1653713820" }
    unit { "C" }
    value { rand(-50..50) }
  end
end