class HandlePaymentsJob < ApplicationJob
  queue_as :default

  def perform
    expired_subscriptions.find_each do |subscription|
      ProcessRebilling.call(subscription: subscription)
    end
  end

  private

  def expired_subscriptions
    Subscription.where(expiration_date: Date.current)
  end
end
