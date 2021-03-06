FactoryGirl.define do
  factory :lease do
    starts_on Date.yesterday
    ends_on 1.year.from_now
    unit
    charges { [build(:charge)] }
    admin_user

    trait :expired do
      starts_on 2.years.ago
      ends_on 1.year.ago
    end

    trait :current do
      starts_on 1.years.ago
      ends_on 1.year.from_now
    end
  end
end
