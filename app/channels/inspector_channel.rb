class InspectorChannel < ApplicationCable::Channel
  def get_histogram(data)
    body = data['body']
    app_cpus = Job.app_cpus(body['bins'].to_i, body['app'], body['cluster'])
    transmit ApplicationController.render(partial: 'app_inspector/histogram',
                                          locals:  { graph_data: app_cpus['graph_data'],
                                                     bin_size:   app_cpus['bin_size'] })
  end
end
