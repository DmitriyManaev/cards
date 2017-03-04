require 'rails_helper'

RSpec.describe Card, type: :model do
  let(:card) { build(:card) }

  describe 'create' do
    it 'with empty original text' do
      card.original_text = ''
      card.save
      expect(card.errors[:original_text]).
          to include('Необходимо заполнить поле.')
    end

    it 'with empty translated text' do
      card.translated_text = ''
      card.save
      expect(card.errors[:translated_text]).
          to include('Необходимо заполнить поле.')
    end

    it 'with empty texts' do
      card.original_text = ''
      card.translated_text = ''
      card.save
      expect(card.errors[:original_text]).
          to include('Вводимые значения должны отличаться.')
    end

    it 'equal_texts' do
      card.original_text = 'house'
      card.translated_text = 'house'
      card.save
      expect(card.errors[:original_text]).
          to include('Вводимые значения должны отличаться.')
    end

    it 'full_downcase' do
      card.original_text = 'hOuse'
      card.translated_text = 'houSe'
      card.save
      expect(card.errors[:original_text]).
          to include('Вводимые значения должны отличаться.')
    end

    it 'valid original and translated texts' do
      card.save
      expect(card.original_text).to eq('дом')
      expect(card.translated_text).to eq('house')
    end

    it 'without errors' do
      card.save
      expect(card.errors.any?).to be false
    end

    it 'set_review_date valid' do
      card.save
      expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
        to eq(Time.zone.now.strftime('%Y-%m-%d %H:%M'))
    end

    it 'witout user_id' do
      card.user_id = ''
      card.save
      expect(card.errors[:user_id]).to include('Ошибка ассоциации.')
    end

    it 'witout block_id' do
      card.block_id = ''
      card.save
      expect(card.errors[:block_id]).
          to include('Выберите колоду из выпадающего списка.')
    end
  end
  
  describe 'check_translation' do
    before do 
      card.save
    end

    it 'valid answer' do
      check_result = card.check_translation('house')
      expect(check_result[:state]).to be true
    end

    it 'invalid answer' do
      check_result = card.check_translation('RoR')
      expect(check_result[:state]).to be false
    end

    it 'full_downcase valid answer' do
      check_result = card.check_translation('HousE')
      expect(check_result[:state]).to be true
    end

    it 'full_downcase invalid answer' do  
      check_result = card.check_translation('RoR')
      expect(check_result[:state]).to be false
    end

    it 'levenshtein_distance state true' do
      check_result = card.check_translation('hous')
      expect(check_result[:state]).to be true
    end

    it 'levenshtein_distance=1' do
      check_result = card.check_translation('hous')
      expect(check_result[:distance]).to be 1
    end

    it 'levenshtein_distance=2' do
      check_result = card.check_translation('hou')
      expect(check_result[:state]).to be false
    end
  end  
end