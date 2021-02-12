require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  # ログイン前
  describe 'not logged in' do
    # ユーザ新規登録
    describe 'user successfully signs up' do
      before do
        # ルートディレクトリに移動
        visit root_path
        # ユーザ登録画面を表示
        click_link "SignUp"
      end
      
      # フォームの入力値が正常
      context 'form input value is valid' do
        # ユーザの新規登録が成功する
        it 'successful new user registration' do
          # ユーザ登録用フォームに正常値を入力し、登録ボタンを押下
          # Userモデルのカウントが１アップしていること。ページ遷移先で"User was successfully created."が表示されていること
          expect {
            fill_in "Email", with: "test@example.com"
            fill_in "Password", with: "password"
            fill_in "Password confirmation", with: "password"
            click_button "SignUp"
          }.to change(User, :count).by(1)
          expect(page).to have_content "User was successfully created."
        end
      end

      # メールアドレスが未入力
      context 'email not entered' do
        # ユーザの新規登録が失敗する
        it 'new user registration fails' do
          # ユーザ登録用フォームにメールアドレスを未入力にした状態で、登録ボタンを押下
          # 新規登録が失敗していること。
          expect {
            fill_in "Email", with: nil
            fill_in "Password", with: "password"
            fill_in "Password confirmation", with: "password"
            click_button "SignUp"
          }.to_not change(User, :count)
          expect(page).to have_content "Email can't be blank"
        end
      end

      # 登録済みのメールアドレスを使用
      context 'use your registered email' do
        # ユーザの新規登録が失敗する
        it 'new user registration fails' do
          # ユーザ登録用フォームにメールアドレスに既に登録済みのメールアドレスを入力し未入力にした状態で、登録ボタンを押下
          # 新規登録が失敗していること。
          user = create(:user)
          expect {
            fill_in "Email", with: user.email
            fill_in "Password", with: "password"
            fill_in "Password confirmation", with: "password"
            click_button "SignUp"
          }.to_not change(User, :count)
          expect(page).to have_content "Email has already been taken"
        end
      end
    end

    # マイページ
    describe 'mypage' do
      # ログインしていない状態
      context 'not logged in' do
        # マイページへのアクセスが失敗する
        it 'access to mypage fails' do
          user = create(:user)
          visit user_path(user)
          expect(page).to have_content "Login required"
        end
      end
    end
  end

  # ログイン後
  describe 'logged in' do
    # ユーザ編集
    describe 'user edit' do
      # フォームの入力値が正常
      context 'form input value is normal' do
        # ユーザの編集が成功する
        it 'user editing succeeds' do
          login_as user
          click_link "Mypage"
          visit edit_user_path(user)
          fill_in "Email", with: "update@example.com"
          fill_in "Password", with: "passwordpassword"
          fill_in "Password confirmation", with: "passwordpassword"
          click_button "Update"
          # save_and_open_page
          expect(page).to have_content "User was successfully updated."
        end
      end

      # メールアドレスが未入力
      context 'email not entered' do
        # ユーザの編集が失敗する
        it 'user editing fails' do
          login_as user
          visit edit_user_path(user)
          fill_in "Email", with: ""
          fill_in "Password", with: "passwordpassword"
          fill_in "Password confirmation", with: "passwordpassword"
          click_button "Update"
          expect(page).to have_content "Email can't be blank"
        end
      end

      # 登録済みのメールアドレスを使用
      context 'use an already registered email' do
        # ユーザの編集が失敗する
        it 'user editing fails' do
          user2 = create(:user, email: "test@example.com")
          login_as user
          visit edit_user_path(user)
          fill_in "Email", with: user2.email
          fill_in "Password", with: "passwordpassword"
          fill_in "Password confirmation", with: "passwordpassword"
          click_button "Update"
          expect(page).to have_content "Email has already been taken"
        end
      end

      # 他ユーザの編集ページにアクセス
      context 'access other user edit pages' do
        # 編集ページへのアクセスが失敗する
        it 'access to edit page fails' do
          login_as user
          visit edit_user_path(other_user)
          expect(page).to have_content "Forbidden access."
        end
      end
    end

    # マイページ
    describe 'mypage' do
      # タスクを作成
      context 'create task' do
        # 新規作成したタスクが表示される
        it 'the newly created task is displayed' do
          login_as user
          click_link "New Task"
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
  end
end
