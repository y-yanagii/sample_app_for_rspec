require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { FactoryBot.create(:user) }
  
  # ログイン前
  describe 'before login' do
    # フォームの入力値が正常
    context 'form input value is normal' do
      # ログイン処理が成功する
      it 'login process succeeds' do
        user = create(:user)
        visit root_path
        click_link "Login"
        fill_in "Email", with: user.email
        fill_in "Password", with: "password"
        click_button "Login"
        expect(page).to have_content "Login successful"
      end
    end

    # フォームが未入力
    context 'no form filled' do
      # ログイン処理が失敗する
      it 'login process fails' do
        visit root_path
        click_link "Login"
        click_button "Login"
        expect(page).to have_content "Login failed"
      end
    end
  end

  # ログアウト
  describe 'logout' do
    login_as user
    click_link "Logout"
    expect(page).to have_content "Logged out"
  end
end
