class AppInspectorController < ApplicationController
  def index
    @app_names = Job.all_app_names
    @cluster_names = Job.all_cluster_names
    @app_cpus = Job.app_cpus(5, @app_names[0])
  end

  def replace_stream
    app_cpus = Job.app_cpus(params[:bins_slider].to_i, params[:app_select], params[:cluster_select])
    opts = {  partial: 'histogram',
              locals:  {
                graph_data:      app_cpus['graph_data'],
                bin_size:        app_cpus['bin_size'],
                hide_empty_bins: params[:hide_empty_bins]
              } }
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('app_inspector_histogram', **opts) }
    end
  end
end
