$LOAD_PATH.unshift File.dirname(__FILE__)
require 'spec_helper'

describe WaseEndpoint::Message do
  
  describe "with no input URI" do
    
    before(:all) do
      raw_message = "@ey-sort #wase, 0, bit.ly/7yQK6, 1256850843, bit.ly/2uhGcl"
      @message = WaseEndpoint::Message.new(123, raw_message)
    end

    it "should return the id" do
      @message.id.should == 123
    end

    it "should return the program counter as an integer" do
      @message.program_counter.should == 0
    end

    it "should return the program listing url without whitespace" do
      @message.program_listing_uri.should == 'bit.ly/7yQK6'
    end

    it "should return the timestamp as an integer" do
      @message.timestamp.should == 1256850843
    end
    
    it "should return the output uri without whitespace" do
      @message.output_uri.should == 'bit.ly/2uhGcl'
    end
    
    it "should return the input uri as nil" do
      @message.input_uri.should be_nil
    end

    it "should return the second input uri as nil" do
      @message.input_uri_1.should be_nil
    end
    
    it "should fetch the program listing as an array" do
      RestClient.should_receive(:get).with('http://bit.ly/7yQK6').and_return('["@ey-sort", "@ey-firsthalf", "@ey-firsthalf", "@engineyard"]')
      
      @message.fetch_program_listing.should == ["@ey-sort", "@ey-firsthalf", "@ey-firsthalf", "@engineyard"]
    end
    
    it "should fetch the output data" do
      RestClient.should_receive(:get).with('http://bit.ly/2uhGcl').and_return('[58, 92, 12, 18, 76]')
      
      @message.fetch_output.should == '[58, 92, 12, 18, 76]'
    end
    
    it "should send the input data using the expanded output URI" do
      mock_net_http = mock(Net::HTTP)
      mock_net_http.should_receive(:head).with('/2uhGcl').and_return({'Location' => 'http://example.com/'})
      Net::HTTP.should_receive(:new).with('bit.ly').and_return(mock_net_http)
      RestClient.should_receive(:put).with('http://example.com/', '[1, 2, 3, 4]')
      
      @message.send_input('[1, 2, 3, 4]')
    end
    
  end
  
  describe "with one input URI" do
    
    before(:all) do
      raw_message = "@ey-sort #wase, 0, bit.ly/7yQK6, 1256850843, bit.ly/2uhGcl, bit.ly/3kl0xs"
      @message = WaseEndpoint::Message.new(123, raw_message)
    end
    
    it "should return the input uri without whitespace" do
      @message.input_uri.should == 'bit.ly/3kl0xs'
    end

    it "should return the second input uri as nil" do
      @message.input_uri_1.should be_nil
    end

    it "should send the input data using the expanded output URI" do
      mock_net_http = mock(Net::HTTP)
      mock_net_http.should_receive(:head).with('/3kl0xs').and_return({'Location' => 'http://example.com/'})
      Net::HTTP.should_receive(:new).with('bit.ly').and_return(mock_net_http)
      RestClient.should_receive(:put).with('http://example.com/', '[1, 2, 3, 4]')

      @message.send_input('[1, 2, 3, 4]')
    end
    
  end
  
  describe "with two input URIs" do
    
    before(:all) do
      raw_message = "@ey-sort #wase, 0, bit.ly/7yQK6, 1256850843, bit.ly/2uhGcl, bit.ly/3kl0xs, bit.ly/3kl0xt"
      @message = WaseEndpoint::Message.new(123, raw_message)
    end

    it "should return the second input uri without whitespace" do
      @message.input_uri_1.should == 'bit.ly/3kl0xt'
    end
    
  end
  
  describe "comparison via ID" do
    
    before(:all) do
      @raw_message = "@ey-sort #wase, 0, bit.ly/7yQK6, 1256850843, bit.ly/2uhGcl"
      @message_1 = WaseEndpoint::Message.new(123, @raw_message)
    end
    
    it "should equal" do
      @message_1.should == WaseEndpoint::Message.new(123, @raw_message) 
    end
    
    it "should not be equal" do
      @message_1.should_not == WaseEndpoint::Message.new(456, @raw_message) 
    end
    
  end
  
end