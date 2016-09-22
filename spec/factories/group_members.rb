FactoryGirl.define do
  factory :group_member do
    group
    team
    sequence(:position)
  end
end
