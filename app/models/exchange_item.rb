class ExchangeItem < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :product

  enum exchange_type: { request_change: 0, reject_change: 1, success_change: 2}
end
