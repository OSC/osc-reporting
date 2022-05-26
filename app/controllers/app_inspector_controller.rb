class AppInspectorController < ApplicationController
  def index
    @app_names = Job.all_names
    @app_cpus = Job.app_cpus
  end
end
