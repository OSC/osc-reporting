class JobsController < ApplicationController
  def index
    @jobs = Job.all
    @pct_jobs = Job.usage_w_percentage(Job.all_by_usage)
    @active_jobs = ActiveJobs.all
  end
end
