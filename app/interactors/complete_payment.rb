class CompletePayment
  include Interactor
  include PaymentRequestable

  delegate :payment, to: :context

  def call
    full_amount = payment.subscription.cost
    remaining_amount = full_amount - payment.paid_amount
    response = send_payment_request(remaining_amount, payment.subscription_id)

    context.fail!(message: 'Payment failed') unless response['status'] == 'success'

    payment.update!(paid_amount: full_amount, state: :paid)
  end
end
