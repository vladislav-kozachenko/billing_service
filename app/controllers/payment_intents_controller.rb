class PaymentIntentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    render json: { status: simulate_payment_response }
  end

  private

  def simulate_payment_response
    %w[success insufficient_funds failed].sample
  end
end
