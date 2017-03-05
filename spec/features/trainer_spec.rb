require 'rails_helper'
include LoginHelper

RSpec.feature "Review cards without blocks", type: :feature do
  describe 'without cards' do
    let(:user) { build(:user) }
    
    before do
      visit root_path
      click_link 'ru'
      create(:user)
      login_for user
      visit trainer_path
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end
end

describe 'review cards with one block' do
  describe 'without cards' do
    let(:user) { build(:user) }

    before do
      create(:user_with_one_block_without_cards)
      login_for user
      visit trainer_path
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe 'training with two cards' do
    let(:user) { build(:user) }

    before do
      create(:user_with_one_block_and_one_card)
      visit trainer_path
      login_for user
    end

    it 'first visit' do
      expect(page).to have_content 'Оригинал'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
    end

    it 'correct translation distance=1' do
      fill_in 'user_translation', with: 'hous'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели перевод c опечаткой.'
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'incorrect translation distance=2' do
      fill_in 'user_translation', with: 'hou'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end
  end

  describe 'training with one card' do
    let(:user) { build(:user) }

    before do
      create(:user_with_one_block_and_one_card)
      visit trainer_path
      login_for user
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end

    it 'incorrect translation distance=2' do
      fill_in 'user_translation', with: 'hou'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation distance=1' do
      fill_in 'user_translation', with: 'hous'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели перевод c опечаткой.'
    end

    it 'correct translation quality=3' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      fill_in 'user_translation', with: 'House'
      click_button 'Проверить'
      expect(page).to have_content 'Текущая карточка'
    end

    it 'correct translation quality=4' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      fill_in 'user_translation', with: 'House'
      click_button 'Проверить'
      fill_in 'user_translation', with: 'House'
      click_button 'Проверить'
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end
end

describe 'review cards with two blocks' do
  let(:user) { build(:user) }

  describe 'training without cards' do

    before do
      create(:user_with_two_blocks_without_cards)
      visit trainer_path
      login_for user
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe 'with current_block and two cards' do
    before do
      create(:user_with_two_blocks_and_two_cards_in_each)
      login_for user
      visit blocks_path
      first(:link, "Сделать текущей").click
      visit trainer_path
    end

    it 'first visit' do
      expect(page).to have_content 'Оригинал'
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
    end

    it 'incorrect translation distance=2' do
      fill_in 'user_translation', with: 'hou'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation distance=1' do
      fill_in 'user_translation', with: 'hous'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели перевод c опечаткой.'
    end
  end
end