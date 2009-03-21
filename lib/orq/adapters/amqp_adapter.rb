require 'mq'

# Adapter providing access to AMQP based message systems from ORQ
class AmqpAdapter
  def initialize(config)
    @config = config
  end
  
  def start
    # Do connection
    @connection = AMQP.connect :host => (@config['host'] || 'localhost'), :port => (@config['port'] || 5672).to_i
    @channel = MQ.new @connection
  end
  
  def subscribe(impulseType, &block)
    raise "No block provided - a block must be provided to the subscribe method" unless block_given?
    
    queue = MQ::Queue.new @channel, impulseType.uri
    exchange = MQ::Exchange.new @channel, :direct, impulseType.uri
    queue.bind(exchange)
    
    queue.subscribe :ack => true do |headers, msg|
      yield impulseType.load(msg)
      headers.ack
    end
  end
  
  def fire(impulseUri, content)
    exchange = MQ::Exchange.new @channel, :direct, impulseUri
    exchange.publish content, :content_type => 'application/json'
  end
end
      