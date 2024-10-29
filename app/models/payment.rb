# == Schema Information
#
# Table name: payments
#
#  id              :bigint           not null, primary key
#  state           :string
#  paid_amount     :decimal(, )
#  subscription_id :bigint           not null
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_payments_on_deleted_at       (deleted_at)
#  index_payments_on_subscription_id  (subscription_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscription_id => subscriptions.id)
#
class Payment < ApplicationRecord
  acts_as_paranoid

  belongs_to :subscription

  state_machine initial: :draft do
    state :draft
    state :partially_paid
    state :paid

    event :partially_pay do
      transition draft: :partially_paid
    end

    event :pay do
      transition draft: :paid
      transition partially_paid: :paid
    end
  end
end
