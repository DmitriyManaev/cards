require 'rails_helper'
include TrainerHelper

describe Dashboard::TrainerController do
  describe 'review_card' do
    before do
      @user = create(:user)
      @block = create(:block, user: @user)
      @card = create(:card, user: @user, block: @block)
      @controller.send(:auto_login, @user)
    end

    describe 'card quality = 5' do
      describe 'base settings' do
        it 'efactor=2.6, quality=5' do
          check_review_card @card
          
          expect(format_date @card.review_date).
              to eq(format_date(time_now + 1.days))
          expect(@card.interval).to eq(6)
          expect(@card.repeat).to eq(2)
          expect(@card.attempt).to eq(1)
          expect(@card.efactor).to eq(2.6)
          expect(@card.quality).to eq(5)
        end

        it 'efactor=2.18, quality=4' do
          check_review_card(@card, 'RoR')
          check_review_card @card
          
          expect(@card.efactor).to eq(2.18)
          expect(@card.quality).to eq(4)
        end

        it 'efactor=1.5, quality=3' do
          check_review_card(@card, 'RoR', 2)
          check_review_card @card
          
          expect(@card.efactor).to eq(1.5)
          expect(@card.quality).to eq(3)
        end

        it 'efactor=1.3, quality=3' do
          check_review_card(@card, 'RoR', 3)
          check_review_card @card
          
          expect(@card.efactor).to eq(1.3)
          expect(@card.quality).to eq(3)
        end

        it 'repeat=1-3 quality=5' do
          check_review_card @card
          @card.update(review_date: time_now)
          check_review_card @card
          @card.update(review_date: time_now)
          check_review_card @card
          
          expect(format_date @card.review_date).
              to eq(format_date(time_now + 16.days))
          expect(@card.interval).to eq(45)
          expect(@card.repeat).to eq(4)
          expect(@card.attempt).to eq(1)
          expect(@card.efactor).to eq(2.8)
          expect(@card.quality).to eq(5)
        end
      end
      
      describe 'interval: 6, repeat: 2, efactor: 2.6' do
        before do
          @card.update(interval: 6, repeat: 2, efactor: 2.6)
        end

        it 'efactor=2.7, quality=5' do
          check_review_card @card
          
          expect(format_date @card.review_date).
              to eq(format_date(time_now + 6.days))
          expect(@card.interval).to eq(16)
          expect(@card.repeat).to eq(3)
          expect(@card.attempt).to eq(1)
          expect(@card.efactor).to eq(2.7)
          expect(@card.quality).to eq(5)
        end

        it 'efactor=2.28, quality=4' do
          check_review_card(@card, 'RoR')
          check_review_card @card
          
          expect(@card.efactor).to eq(2.28)
          expect(@card.quality).to eq(4)
        end

        it 'efactor=1.6, quality=3' do
          check_review_card(@card, 'RoR', 2)
          check_review_card @card
          
          expect(@card.efactor).to eq(1.6)
          expect(@card.quality).to eq(3)
        end

        it 'efactor=1.3, quality=3' do
          check_review_card(@card, 'RoR', 3)
          check_review_card @card
          
          expect(@card.efactor).to eq(1.3)
          expect(@card.quality).to eq(3)
        end
      end
      
      describe 'interval: 16, repeat: 3, efactor: 2.7' do
        before do
          @card.update(interval: 16, repeat: 3, efactor: 2.7)
        end

        it 'efactor=2.8, quality=5' do
          check_review_card @card
          
          expect(format_date @card.review_date).
              to eq(format_date(time_now + 16.days))
          expect(@card.interval).to eq(45)
          expect(@card.repeat).to eq(4)
          expect(@card.attempt).to eq(1)
          expect(@card.efactor).to eq(2.8)
          expect(@card.quality).to eq(5)
        end

        it 'efactor=2.38, quality=4' do
          check_review_card(@card, 'RoR')
          check_review_card @card
          
          expect(@card.efactor).to eq(2.38)
          expect(@card.quality).to eq(4)
        end

        it 'efactor=1.7, quality=3' do
          check_review_card(@card, 'RoR', 2)
          check_review_card @card
          
          expect(@card.efactor).to eq(1.7)
          expect(@card.quality).to eq(3)
        end

        it 'efactor=1.3, quality=3' do
          check_review_card(@card, 'RoR', 3)
          check_review_card @card
          
          expect(@card.efactor).to eq(1.3)
          expect(@card.quality).to eq(3)
        end

        it 'repeat=3 attempt=4' do
          check_review_card(@card, 'RoR', 3)
          check_review_card @card
          
          expect(format_date @card.review_date).
              to eq(format_date(time_now + 1.days))
          expect(@card.interval).to eq(6)
          expect(@card.repeat).to eq(2)
          expect(@card.attempt).to eq(1)
          expect(@card.efactor).to eq(1.3)
          expect(@card.quality).to eq(3)
        end
      end
    end

    describe 'card quality = 4' do
      before do
        @card.update(quality: 4)
      end

      it 'attempt=2' do
        check_review_card(@card, 'RoR')
        
        expect(@card.interval).to eq(1)
        expect(@card.repeat).to eq(1)
        expect(@card.attempt).to eq(2)
        expect(@card.efactor).to eq(2.18)
        expect(@card.quality).to eq(2)
      end

      it 'attempt=3' do
        check_review_card(@card, 'RoR', 2)
        
        expect(@card.interval).to eq(1)
        expect(@card.repeat).to eq(1)
        expect(@card.attempt).to eq(3)
        expect(@card.efactor).to eq(1.64)
        expect(@card.quality).to eq(1)
      end

      it 'attempt=4' do
        check_review_card(@card, 'RoR', 3)
        
        expect(@card.interval).to eq(1)
        expect(@card.repeat).to eq(1)
        expect(@card.attempt).to eq(4)
        expect(@card.efactor).to eq(1.3)
        expect(@card.quality).to eq(0)
      end

      it 'repeat=1-3 quality=4' do
        check_review_card @card
        @card.update(review_date: time_now)
        check_review_card @card 
        @card.update(review_date: time_now)
        check_review_card(@card, 'RoR')
        check_review_card @card
        
        expect(format_date @card.review_date).
            to eq(format_date(time_now + 1.days))
        expect(@card.interval).to eq(6)
        expect(@card.repeat).to eq(2)
        expect(@card.attempt).to eq(1)
        expect(@card.efactor).to eq(2.38)
        expect(@card.quality).to eq(4)
      end

      it 'repeat=1-3 quality=5' do
        check_review_card @card
        @card.update(review_date: time_now)
        check_review_card(@card, 'RoR')
        check_review_card @card
        @card.update(review_date: time_now)
        check_review_card @card
        
        expect(format_date @card.review_date).
            to eq(format_date(time_now + 6.days))
        expect(@card.interval).to eq(14)
        expect(@card.repeat).to eq(3)
        expect(@card.attempt).to eq(1)
        expect(@card.efactor).to eq(2.38)
        expect(@card.quality).to eq(5)
      end
    end
  end
end