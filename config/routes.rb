Rails.application.routes.draw do
  post '/paymentIntents/create', to: 'payment_intents#create'
end
