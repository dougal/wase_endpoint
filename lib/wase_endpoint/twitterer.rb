class WaseEndpoint
  class Twitterer
        
    def initialize(username, password)
      twitter_http_auth = Twitter::HTTPAuth.new(username, password)
      @twitter_client = Twitter::Base.new(twitter_http_auth)
      
      # Call the test api method to validate the authentication.
      @twitter_client.help
      
      # The oldest message ID could be stored here, but since twitter IDs
      # aren't always time-linear, comparing the messages is safer.
      @all_messages = []
    end
    
    # Fetches the timeline and returns any new messages.
    def fetch
      new_messages = []
      
      # Ignore any messages that don't have the hashtag.
      # Use twitter search to do this instead?
      @twitter_client.replies.reject{|m| !m.text[/#wase/]}.each do |reply|
        message = Message.new(reply.id, reply.text)
        
        # Skip if we've already processed this message.
        unless @all_messages.include?(message)
          @all_messages << message
          new_messages << message
        end
      end
      new_messages
    end
    
    def send(recipient, program_counter, program_list_uri, output_uri, input_uri=nil, input_uri_1=nil)
      text = ["#{recipient} #wase", program_counter, program_list_uri, Time.now.utc.to_i, output_uri, input_uri, input_uri_1].compact.join(', ')
      @twitter_client.update(text)
    end
    
  end
end