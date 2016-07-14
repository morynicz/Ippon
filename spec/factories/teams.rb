FactoryGirl.define do
  factory :team do
    name {Faker::Lorem.word}
    required_size 1
    tournament {FactoryGirl::create(:tournament)}
  end
end
