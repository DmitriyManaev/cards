require 'rails_helper'
include LoginHelper

RSpec.feature "Password authentication", type: :feature do
  describe 'sign up' do
    let(:user) { build(:user) }
    
    before do
      visit new_user_path
    end

    it 'sign up successful' do
      sign_up_for user
      expect(page).to have_content 'Пользователь успешно создан.'
    end

    it 'incorrect password confirmation' do
      user.password_confirmation = '56789'
      sign_up_for user
      expect(page).to have_content "Значения не совпадают."
    end

    it 'incorrect email' do
      user.email = 'test'
      sign_up_for user
      expect(page).to have_content 'Не верный формат.'
    end

    it 'email has already been taken' do
      user.save
      sign_up_for user
      expect(page).to have_content 'Не уникальное значение.'
    end

    it 'password is too short' do
      user.password = '1'
      sign_up_for user
      expect(page).to have_content 'Короткое значение.'
    end

    it 'incorrect password_confirmation' do
      user.password_confirmation = '1'
      sign_up_for user
      expect(page).to have_content 'Значения не совпадают.'
    end
  end

  describe 'authentication' do
    let(:user) { build(:user) }
    
    before do
      create(:user)
    end

    it 'successful' do
      login_for user
      expect(page).to have_content 'Вход выполнен успешно.'
    end

    it 'incorrect email' do
      user.email = '1@1.com'
      login_for user
      expect(page).
          to have_content 'Вход не выполнен. Проверте вводимые E-mail и Пароль.'
    end

    it 'incorrect password' do
      user.password = '56789'
      login_for user
      expect(page).
          to have_content 'Вход не выполнен. Проверте вводимые E-mail и Пароль.'
    end
  end

  describe 'change language' do
    let(:user) { build(:user) }

    before do
      visit root_path
      click_link 'en'
      visit new_user_path
    end

    it 'sign up successful' do
      sign_up_for user
      expect(page).to have_content 'User created successfully.'
    end

    it 'user has correct locale' do
      email = user.email
      sign_up_for user

      user = User.find_by_email(email)
      expect(user.locale).to eq('en')
    end

    it 'edit profile successful' do
      sign_up_for user
      click_link 'User profile'
      fill_in 'user[password]', with: '12345'
      fill_in 'user[password_confirmation]', with: '12345'
      find('input[name="commit"]').click

      expect(page).to have_content 'Profile updated successfully.'
    end

    it 'authentication successful' do
      create(:user)
      login_for user
      expect(page).to have_content 'Login is successful.'
    end
  end
end
