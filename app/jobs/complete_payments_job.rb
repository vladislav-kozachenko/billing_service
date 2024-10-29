class CompletePaymentsJob < ApplicationJob
  queue_as :default

  def perform
    partially_paid_payments.find_each do |payment|
      CompletePayment.call(payment: payment)
    end
  end

  private

  def partially_paid_payments
    date = 1.week.ago
    Payment.where(state: :partially_paid, created_at: date.midnight..date.end_of_day)
  end
end
