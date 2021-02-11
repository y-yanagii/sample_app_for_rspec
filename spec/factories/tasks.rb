FactoryBot.define do
  factory :task, class: Task do
    sequence(:title) { |n| "Title Test #{n}" }
    content { 'Content Task' }
    status { 0 }
    deadline { Time.now }
    association :user

    trait :invalid_title do
      title { nil }
    end

    trait :invalid_content do
      content { nil }
    end

    trait :invalid_status do
      status { nil }
    end
  end
end
