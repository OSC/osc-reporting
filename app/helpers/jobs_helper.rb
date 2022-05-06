module JobsHelper
  def get_cluster_info(jobs)
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
end
