class WaseEndpoint
  
  class Message
    
    attr_reader :program_counter, :program_listing_uri, :timestamp, :output_uri, :input_uri, :input_uri_1, :id
    
    def initialize(id, raw_message)
      myname_and_hashtag, program_counter, program_listing_uri, unix_timestamp, output_uri, input_uri, input_uri_1 = raw_message.split(/,/)
      
      @id = id
      @program_counter = program_counter.to_i
      @program_listing_uri = program_listing_uri.strip
      @timestamp = unix_timestamp.to_i
      @output_uri = output_uri.strip
      @input_uri = input_uri.strip if input_uri
      @input_uri_1 = input_uri_1.strip if input_uri_1
      @increment = 1
    end
    
    def ==(other)
      @id == other.id
    end
    
    def fetch_program_listing
      JSON.parse(RestClient.get('http://' + @program_listing_uri))
    end
    
    def fetch_output
      RestClient.get('http://' + @output_uri)
    end
    
    # Accepts either a String of raw data, or a Hash of data and a program
    # counter increment.
    # An Exception will be thrown if this increment is negative.
    def send_input(input)
      
      if input.is_a?(Hash)
        @increment = input[:increment]
        raise ArgumentError, 'You cannot have negative program counter increments' if @increment < 0
        input = input[:data]
      end
      
      input_uri = 'http://' + (@input_uri || @output_uri)
      
      # RestClient can't follow a redirect for put, so we'll expand it.
      input_uri[/bit\.ly(\/\w+)/]
      expanded_input_uri = Net::HTTP.new('bit.ly').head($1)['Location']
      
      RestClient.put(expanded_input_uri, input)
    end
    
    def new_program_counter
      @program_counter + @increment
    end
    
  end
  
end
