FactoryGirl.define do
  factory :location do
    sequence(:name, 'A') {|n| "Shiaijo #{n}"}
    tournament
  end
end
