redis_conf = {
  url: Rails.application.credentials.redis[:url],
  network_timeout: Rails.application.credentials.redis[:network_timeout],
  db: 0,
  id: nil
}

Sidekiq.configure_server do |config|
  config.redis = redis_conf

  config.on(:startup) do
    require 'sidekiq-scheduler'
    schedule = YAML.load_file(Rails.root.join('config/sidekiq_scheduler.yml'))
    Sidekiq.schedule = Sidekiq.schedule.merge(schedule) { raise 'Duplicate key in sidekiq-scheduler' }
    SidekiqScheduler::Scheduler.instance.reload_schedule!

    ISO3166::Data.update_cache
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_conf
end
