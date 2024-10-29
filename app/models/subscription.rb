# == Schema Information
#
# Table name: subscriptions
#
#  id              :bigint           not null, primary key
#  expiration_date :date
#  cost            :decimal(, )
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_deleted_at  (deleted_at)
#
class Subscription < ApplicationRecord
  acts_as_paranoid
  
  has_many :payments, dependent: :destroy
end
