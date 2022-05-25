class AppInspectorController < ApplicationController
  def index
    @app_names = Job.all_names
    @app_inspector_data = Job.app_inspector_histogram_data
  end
end
