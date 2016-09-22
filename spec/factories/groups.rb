FactoryGirl.define do
  factory :group do
    tournament
    sequence(:name, 'A') {|n| "Group #{n}"}
  end
end
