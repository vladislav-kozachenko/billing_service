# frozen_string_literal: true

class BillingLogger
  class << self
    def handle_message(message, params = {})
      puts message, params.to_s
    end
  end
end
