class InspectorChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    puts "INSPECTORCHANNEL: " + data
    ActionCable.server.broadcast('message', 'hello from ruby')
  end

  def get_histogram
    puts 'hello from the other side'

    # app_cpus = Job.app_cpus(params[:bins_slider].to_i, params[:app_select], params[:cluster_select])
    # opts = {  partial: 'histogram',
    #           locals:  { graph_data: app_cpus['graph_data'], bin_size: app_cpus['bin_size'] } }
    # respond_to do |format|
    #   format.turbo_stream { render turbo_stream: turbo_stream.replace('app_inspector_histogram', **opts) }
    # end
  end
end
