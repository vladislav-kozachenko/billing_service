# frozen_string_literal: true

module PaymentRequestable
  extend ActiveSupport::Concern

  def send_payment_request(amount, subscription_id)
    uri = URI(PAYMENT_INTENTS_URL)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = { amount: amount, subscription_id: subscription_id }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(request) }
    JSON.parse(response.body)
  rescue StandardError => e
    BillingLogger.handle_message "Error sending payment request: #{e.message}"
    { 'status' => 'failed' }
  end
end
