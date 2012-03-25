FactoryGirl.define do
  factory :role do
    title 'noob'
  end

  factory :user do
    name 'bob'
    sequence(:email) { |n| "bob#{n}@example.com" }
    default_password = 'secret'
    roles [Factory(:role)]
  
    after_create { |u| #need to reset the password since the User model generates a random one.
      u.password = default_password
      u.password_confirmation = default_password
      u.save!
    }
  end
    
  factory :permission do
    title "admin"
  end

  factory :strike do
    reason Strike::Reasons[0]
    severity 3
    offense_on Time.now
    association :sinner, :factory => :user
    association :striker, :factory => :user
  end

  factory :special_event do
    title "Special Event: Super Secret!"
    description "Description"
    association :schedule_event
  end

  factory :schedule_event do
    sequence(:starts_at_time) { |n| (Time.zone.now + 60*60*n).hour }
    sequence(:ends_at_time) { |n| (Time.zone.now + 60*60*(2+n)).hour }
    sequence(:starts_at_date) { |n| (Time.zone.now + 60*60*24*n).beginning_of_day }
    sequence(:starts_at_date) { |n| (Time.zone.now + 60*60*24*n).tomorrow }
  end

  factory :forum do
    #
  end

  factory :topic do
    title "This is a topic title."
    association :forum
    association :initial_message, :factory => :message
    association :user
  end

  factory :message do
    body "This is a post."
  end

  factory :show do
    sequence(:title) { |n| "Show Name #{n}" }
  end

  factory :post do
    sequence(:title) { |n| "Post Title #{n}" }
    body "This is a post. This is a post. This is a post. This is a post.\nThis is a post."
  end

  factory :song do
    title "Song Title"
    artist "Song Artist"
    album "Song Album"
  end
end
