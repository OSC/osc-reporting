class JobsController < ApplicationController
  def index
    @jobs = Job.all
    @pct_jobs = Job.usage_w_percentage(Job.all_by_usage)
    #@active_jobs = ActiveJobs.all
    #@cluster_ids = ActiveJobs.clusters.map { |c| c.id }
    @clusters_with_info = ActiveJobs.clusters_with_info
  end
end
