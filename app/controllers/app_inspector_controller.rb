class AppInspectorController < ApplicationController
  def index
    @app_names = Job.all_app_names
    @cluster_names = Job.all_cluster_names
    @app_cpus = Job.app_inspect(5, @app_names[0])
  end

  def replace_stream
    data = Job.app_inspect(params[:bins_slider].to_i, params[:app_select], params[:cluster_select], params[:property_select])
    opts = {  partial: 'histogram',
              locals:  {
                graph_data: data['graph_data'],
                bin_size:   data['bin_size']
              } }
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('app_inspector_histogram', **opts) }
    end
  end
end
