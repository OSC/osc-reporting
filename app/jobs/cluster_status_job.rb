class ClusterStatusJob < ApplicationJob
  queue_as :default

  class << self
    def info_from_jobs(jobs)
      gpu_jobs_running = jobs.count { |job| job.status == 'running' && job.native[:gres].include?("gpu") }
      gpu_jobs_queued = jobs.count { |job| job.status == 'queued' && job.native[:gres].include?("gpu") }
      jobs_running = jobs.count { |job| job.status == 'running' }
      jobs_queued = jobs.count { |job| job.status == 'queued' }
      {
        'gpu_jobs_running':     gpu_jobs_running,
        'gpu_jobs_queued':      gpu_jobs_queued,
        'gpu_jobs_running_pct': (gpu_jobs_running + gpu_jobs_queued != 0) ? (gpu_jobs_running.to_f / (gpu_jobs_running + gpu_jobs_queued) * 100).to_i : 0,
        'gpu_jobs_queued_pct':  (gpu_jobs_running + gpu_jobs_queued != 0) ? (gpu_jobs_queued.to_f / (gpu_jobs_running + gpu_jobs_queued) * 100).to_i : 0,
        'jobs_running':         jobs_running,
        'jobs_queued':          jobs_queued,
        'jobs_running_pct':     (jobs_running + jobs_queued != 0) ? (jobs_running.to_f / (jobs_running + jobs_queued) * 100).to_i : 0,
        'jobs_queued_pct':      (jobs_running + jobs_queued != 0) ? (jobs_queued.to_f / (jobs_running + jobs_queued) * 100).to_i : 0
      }
    end

    def clusters
      Rails.cache.fetch('clusters', expires_in: 12.hours) do
        OodCore::Clusters.load_file('/etc/ood/config/clusters.d/').reject do |c|
          !c.errors.empty? || !c.allow? || c.kubernetes? || c.linux_host?
        end
      end
    end
  end

  def perform(cluster_id)
    # cluster = clusters[cluster_id.to_sym]
    # info = info_from_jobs(cluster.job_adapter.info_all)
    # broadcast info
    puts "current time is #{Time.now}"
  end

  def perform_forever(cluster_id)
    perform(cluster_id)
    perform_forever(wait: RUN_EVERY)
  end
end
