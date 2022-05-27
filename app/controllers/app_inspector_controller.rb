class AppInspectorController < ApplicationController
  def index
    @app_names = Job.all_names
    @app_cpus = Job.app_cpus(5, @app_names[0])
  end

  def replace_stream
    app_cpus = Job.app_cpus(params[:bins_count].to_i, params[:app_inspector_selector])
    opts = {  partial: 'histogram',
              locals:  { graph_data: app_cpus['graph_data'], bin_size: app_cpus['bin_size'] } }
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('app_inspector_histogram', **opts) }
    end
  end
end
