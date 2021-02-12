require 'rails_helper'

RSpec.describe "Tasks", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:task) { FactoryBot.create(:task, user: user) }

  # ログイン後
  describe 'logged in' do
    # タスクの新規作成
    describe 'create new task' do
      # フォームの入力値が正常
      context 'form input value is valid' do
        # タスクの新規登録が成功すること
        it 'successful new registration of task' do
          login_as user
          click_link 'New Task'
          expect {
            fill_in "Title", with: "test title"
            fill_in "Content", with: "test content"
            select "todo", from: "task_status"
            fill_in "Deadline", with: 1.week.from_now
            click_button "Create Task"
          }.to change(Task, :count).by(1)
          expect(page).to have_content "Task was successfully created."
        end
      end
    end

    # タスクの編集
    describe 'edit task' do
      # フォームの入力値が正常
      context 'form input value is valid' do
        # タスクの更新が成功すること
        it 'successful task update' do
          task = create(:task, user: user)
          task.reload
          login_as user
          click_link "Show"
          click_link "Edit"
          expect {
            fill_in "Title", with: "update title"
            fill_in "Content", with: "update content"
            select "doing", from: "task_status"
            fill_in "Deadline", with: 2.week.from_now
            click_button "Update Task"
          }
          # save_and_open_page
          # expect(page).to have_content "Task was successfully updated."
        end
      end
    end

    # タスクの削除
    describe 'delete task' do
      # 正常に削除
      context 'deleted successfully' do
        it 'successful task delete' do
          task = create(:task, user: user)
          task.reload
          login_as user
          click_link "Destroy"
          click_on :delete_button
          expect(page).to have_content "Task was successfully destroyed."
        end
      end
    end
  end
end
