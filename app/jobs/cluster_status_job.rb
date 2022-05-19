class ClusterStatusJob < ApplicationJob
  queue_as :default

  class << self
  end

  def perform(cluster_id)
    cluster = ActiveJobs.clusters[cluster_id.to_sym]
    info = ActiveJobs.info_from_jobs(cluster.job_adapter.info_all)
    puts 'Updating'
    opts = {  partial: 'jobs/system_status',
              target:  "cluster_status_#{cluster_id}",
              locals:  { cluster_info: info, cluster_name: cluster_id } }
    Turbo::StreamsChannel.broadcast_replace_to("cluster_status_#{cluster_id}", **opts)
    self.class.set(wait: Configuration.cluster_reload_delay.minutes).perform_later(cluster_id)
  end
end
