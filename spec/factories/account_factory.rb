FactoryGirl.define do
  factory :account do
    name "MyString"
    units_count 1
    active false
    admin_user
  end
end
