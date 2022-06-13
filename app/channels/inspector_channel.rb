class InspectorChannel < ApplicationCable::Channel
  def subscribed
    stream_from "inspector_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    puts "INSPECTORCHANNEL: #{data}"
  end

  def get_histogram(data)
    body = data['body']
    app_cpus = Job.app_cpus(body['bins'].to_i, body['app'], body['cluster'])
    transmit ApplicationController.render(partial: 'app_inspector/histogram',
                                          locals:  { graph_data: app_cpus['graph_data'],
                                                     bin_size:   app_cpus['bin_size'] })
  end
end
