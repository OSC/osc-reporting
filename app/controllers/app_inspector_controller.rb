class AppInspectorController < ApplicationController
  def index
    @app_inspector_data = Job.app_inspector_data_js
  end
end
