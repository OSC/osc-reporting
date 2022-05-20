class SimpleScheduler
  include Singleton

  def self.start
    Thread.new do
      Kernel.loop do
        item = @queue.pop
        if item.nil?
          sleep 10
        else
          if item[:time] < Time.now && item[:block].responds_to?(:call)
            yield item[:block]
            item[:time] = Time.now + time[:delay]
          end

          @queue << item
        end
      end
    end
  end

  def self.run_every(minutes, &block)
    return if minutes.nil? || minutes.to_i.zero? || !block_given?

    item = {
      time: Time.now + minutes.to_i.minutes,
      delay: minutes.to_i.minutes,
      run: block,
    }

    @queue << item
  end

  private

  @queue = []
end