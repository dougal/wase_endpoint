require 'rubygems'
require 'twitter'
require 'json'
require 'rest_client'
require 'robustthread'

require 'wase_endpoint/message'
require 'wase_endpoint/twitterer'

class WaseEndpoint
  
  def initialize(options={})
    @logger = Logger.new(options[:logfile])
    @twitterer = Twitterer.new(options[:username], options[:password])
    @sleep_period = options[:sleep_period] || 60
    
    start
  end
  
  # Override this.
  # Argument is a json encoded string.
  # Should return a json encoded string.
  def secret_sauce(raw_json)
    raise Exception, 'You need to override secret_sauce'
  end
  
  protected
  
  def logger
    @logger
  end
  
  def start
    RobustThread.logger = @logger
    pid = fork do
      RobustThread.loop(:seconds => @sleep_period, :label => 'Checking for new messages and processing them') do
        
        # Grab any new messages.
        messages = @twitterer.fetch
        @logger.info "Processing #{messages.size} messages"
        
        messages.each do |message|
          program_listing = message.fetch_program_listing
          if message.program_counter >= program_listing.size
            throw Exception 'Program counter has gone too far'
          end
          
          # Here's where your magic happens.
          message.send_input(secret_sauce(message.fetch_output))
          
          # Tell the next endpoint.
          @twitterer.send(program_listing[message.program_counter + 1], message.program_counter + 1, message.program_listing_uri, message.output_uri)
        end
        
      end
      sleep
    end
    puts pid
    Process.detach pid
  end
  
end
