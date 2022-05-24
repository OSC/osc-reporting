# Be sure to restart your server when you modify this file.

Rails.application.config.after_initialize do
  ActiveJobs.clusters.each do |cluster|
    ClusterStatusJob.perform_later(cluster.id)
  end
end
