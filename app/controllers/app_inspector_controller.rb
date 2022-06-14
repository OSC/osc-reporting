class AppInspectorController < ApplicationController
  def index
    @app_names = Job.all_app_names
    @cluster_names = Job.all_cluster_names
    @app_cpus = Job.app_cpus(5, @app_names[0])
  end
end
