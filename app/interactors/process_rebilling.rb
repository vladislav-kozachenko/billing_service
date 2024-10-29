require 'net/http'

class ProcessRebilling
  MAX_ATTEMPTS = 4
  REDUCTION_PERCENTAGES = [1.0, 0.75, 0.5, 0.25].freeze
  PAYMENT_INTENTS_URL = 'http://localhost:3000/paymentIntents/create'.freeze

  include Interactor
  include PaymentRequestable

  delegate :subscription, to: :context

  def call
    context.payment = subscription.payments.build

    REDUCTION_PERCENTAGES.each_with_index do |percentage, attempt|
      amount_to_charge = (subscription.cost * percentage).round(2)

      response = send_payment_request(amount_to_charge, subscription.id)

      log_attempt(attempt + 1, amount_to_charge, response['status'])

      case response['status']
      when 'success'
        context.payment.state = amount_to_charge < subscription.cost ? 'partially_paid' : 'paid'
        context.payment.paid_amount = amount_to_charge
        context.payment.save!
        update_subscription_expiration
        return
      when 'insufficient_funds'
        next if attempt < MAX_ATTEMPTS - 1
      else
        context.fail!(message: "Payment failed after #{attempt + 1} attempts")
      end
    end
  end

  private

  def update_subscription_expiration
    subscription.update(expiration_date: Date.current + 1.month)
  end

  def log_attempt(attempt, amount, status)
    BillingLogger.handle_message "[Attempt #{attempt}] Tried charging #{amount}, Status: #{status}"
  end
end
