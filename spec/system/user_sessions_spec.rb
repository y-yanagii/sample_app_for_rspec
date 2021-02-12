require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { FactoryBot.create(:user) }

  # ログイン前
  describe 'before login' do
    # フォームの入力値が正常
    context 'form input value is normal' do
      # ログイン処理が成功する
      it 'login process succeeds' do
        visit root_path
        click_link "Login"
        fill_in "Email", with: user.email
        fill_in "Password", with: "password"
        click_button "Login"
        expect(page).to have_content "Login successful"
        expect(current_path).to eq root_path
      end
    end

    # フォームが未入力
    context 'no form filled' do
      it 'ログイン処理が失敗する' do
        visit login_path
        fill_in 'Email', with: ''
        fill_in 'Password', with: 'password'
        click_button 'Login'
        expect(page).to have_content 'Login failed'
        expect(current_path).to eq login_path
      end
    end
  end

  # ログアウト
  describe 'logout' do
    context 'click logout button' do
      it 'ログアウト処理が成功する' do
        login_as(user)
        click_link "Logout"
        expect(page).to have_content "Logged out"
        expect(current_path).to eq root_path
      end
    end
  end
end
