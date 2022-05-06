module JobsHelper
  def get_cluster_info(jobs)
    gpu_using = jobs.count { |job| job.status == 'running' && job.native[:gres].include?("gpu") }
    gpu_requesting = jobs.count { |job| job.status == 'queued' && job.native[:gres].include?("gpu") }
    jobs_running = jobs.count { |job| job.status == 'running' }
    jobs_queued = jobs.count { |job| job.status == 'queued' }
    {
      'gpu_using':          gpu_using,
      'gpu_requesting':     gpu_requesting,
      'gpu_using_pct':      (gpu_using + gpu_requesting != 0) ? (gpu_using.to_f / (gpu_using + gpu_requesting) * 100).to_i : 0,
      'gpu_requesting_pct': (gpu_using + gpu_requesting != 0) ? (gpu_requesting.to_f / (gpu_using + gpu_requesting) * 100).to_i : 0,
      'jobs_running':       jobs_running,
      'jobs_queued':        jobs_queued,
      'jobs_running_pct':   (jobs_running + jobs_queued != 0) ? (jobs_running.to_f / (jobs_running + jobs_queued) * 100).to_i : 0,
      'jobs_queued_pct':    (jobs_running + jobs_queued != 0) ? (jobs_queued.to_f / (jobs_running + jobs_queued) * 100).to_i : 0
    }
  end
end
