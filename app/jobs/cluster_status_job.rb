class ClusterStatusJob < ApplicationJob
  queue_as :default

  class << self
  end

  def perform(cluster_id)
    cluster_info = ActiveJobs.cluster_info(cluster_id)
    Rails.logger.debug("Updating with #{cluster_info.inspect}")
    opts = {  partial: 'jobs/system_status',
              target:  "cluster_status_#{cluster_id}",
              locals:  { cluster_info: cluster_info['info'], cluster_name: cluster_id } }
    Turbo::StreamsChannel.broadcast_replace_to("cluster_status_#{cluster_id}", **opts)
    self.class.set(wait: Configuration.cluster_reload_delay.minutes).perform_later(cluster_id)
  end
end
