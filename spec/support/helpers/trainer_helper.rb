module TrainerHelper
  def check_review_card(card, translate = card.translated_text, number = 1)
    number.times {
      put :review_card, { card_id: card.id, user_translation: translate }
    }

    @card = Card.find(card.id)
  end

  def format_date date
    date.strftime('%Y-%m-%d %H:%M')
  end

  def time_now
    Time.zone.now
  end
end
