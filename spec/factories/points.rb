FactoryGirl.define do
  factory :point do
    fight
    player {fight.aka}
    type :kote
  end
end
