module LoginMacros
  # ログイン処理(capybara)
  def login_as(user)
    visit root_path
    click_link "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Login"
  end
end

# RSpecの設定LoginSupportをinclude（初期化）
RSpec.configure do |config|
  config.include LoginMacros
end