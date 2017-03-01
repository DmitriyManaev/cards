module LoginHelper
  def login(email, password, action)
    click_link action
    fill_in 'email', with: email
    fill_in 'password', with: password
    click_button action
  end
  
  def login_for user
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    find('input[name="commit"]').click
  end

  def sign_up_for user
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    fill_in 'user[password_confirmation]', with: user.password_confirmation
    find('input[name="commit"]').click
  end
end
