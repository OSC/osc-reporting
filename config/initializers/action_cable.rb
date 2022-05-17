
env = Rails.env.dev? ? 'dev' : 'sys'
ActionCable.server.config.mount_path = "/pun/#{env}/dashboard"
# ActionCable.server.config.cable = { adapter: 'async' }
