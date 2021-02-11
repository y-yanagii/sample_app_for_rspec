require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:task) { FactoryBot.create(:task) }

  describe "#task validation check" do
    it "has a valid factory of task" do
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    it "is invalid without a title" do
      task = FactoryBot.build(:task, :invalid_title)
      expect(task).to be_invalid
      expect(task.errors[:title]).to include("can't be blank")
    end

    it "is invalid with a status" do
      task = FactoryBot.build(:task, :invalid_status)
      expect(task).to be_invalid
      expect(task.errors[:status]).to include("can't be blank")
    end

    it "is invalid with a duplicate title" do
      task2 = Task.new(
        title: task.title,
        content: "test content",
        status: 0,
        deadline: Time.now,
        user: user
      )
      task2.invalid?
      expect(task2.errors[:title]).to include("has already been taken")
    end

    it "is valid with another title" do
      task2 = Task.new(
        title: task.title + "2",
        content: "test content",
        status: 0,
        deadline: Time.now,
        user: user
      )
      expect(task2).to be_valid
    end
  end
end
