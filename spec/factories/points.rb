FactoryGirl.define do
  factory :point do
    fight
    player {fight.aka}
    type 1
  end
end
