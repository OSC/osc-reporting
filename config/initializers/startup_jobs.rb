# Be sure to restart your server when you modify this file.

Rails.application.config.after_initialize do
  ClusterStatusJob.perform_now('owens')
end
