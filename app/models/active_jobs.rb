# frozen_string_literal: true

class ActiveJobs

  ALL_LOCK = Mutex.new

  class << self
    def clusters
      Rails.cache.fetch('clusters', expires_in: 12.hours) do
        OodCore::Clusters.new(
          OodCore::Clusters.load_file(Configuration.clusters_config_dir).reject do |c|
            !c.errors.empty? || !c.allow? || c.kubernetes? || c.linux_host?
          end
        )
      end
    end

    def all
      Rails.logger.debug("ActiveJobs.all being called at at #{Time.now}")
      ALL_LOCK.synchronize do
        Rails.cache.fetch('all_jobs', expires_in: 50.seconds) do
          Rails.logger.debug("ActiveJobs fetching new jobs at #{Time.now}")

          clusters.map do |c|
            jobs = info_all(c)
            {
              'cluster_name' => c.id,
              'info'    => info_from_jobs(jobs)
            }
          end
        end
      end
    end

    def cluster_info(cluster_id)
      ActiveJobs.all.select { |info| info['cluster_name'] == cluster_id }.first
    end

    private

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

    def info_all(cluster)
      cluster.job_adapter.info_all
    rescue StandardError => e
      Rails.logger.warn("could not get jobs from #{cluster.id} due to error: #{e.message}")
      []
    end
  end
end
