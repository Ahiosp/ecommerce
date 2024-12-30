class Order < ApplicationRecord
  belongs_to :user
  belongs_to :cart
  monetize :total_amount_cents

  validates :state, presence: true
  validates :checkout_session_id, presence: true, if: :session_created?

  private
  def session_created?
    checkout_session_id.present?
  end
end
