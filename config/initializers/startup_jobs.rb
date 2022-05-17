# Be sure to restart your server when you modify this file.

Rails.application.config.after_initialize do
  ClusterStatusJob.clusters.each do |cluster|
    ClusterStatusJob.perform_now(cluster.id)
  end
end
