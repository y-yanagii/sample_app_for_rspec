FactoryBot.define do
  factory :task, class: Task do
    sequence(:title, "title_1")
    content { "content" }
    status { :todo }
    deadline { 1.week.from_now }
    association :user
  end
end
