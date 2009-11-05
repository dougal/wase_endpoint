$LOAD_PATH.unshift File.dirname(__FILE__)
require 'spec_helper'

describe WaseEndpoint::Twitterer do
  
  it "should return a twitter client object" do
    username ='foo'
    password = 'bar'
    Twitter::HTTPAuth.should_receive(:new).with(username, password).and_return(mock_twitter_http_auth)
    Twitter::Base.should_receive(:new).with(mock_twitter_http_auth).and_return(mock_twitter_base)
    
    WaseEndpoint::Twitterer.new(username, password)
  end
  
  describe "fetching messages" do
    
    before(:all) do
      username ='foo'
      password = 'bar'
      Twitter::HTTPAuth.stub(:new)
      Twitter::Base.stub(:new).and_return(mock_twitter_base)

      @twitterer = WaseEndpoint::Twitterer.new(username, password)
    end
    
    it "should return the latest message" do
      mock_twitter_base.should_receive(:replies).and_return([mock_mash(123)])
      messages = @twitterer.fetch
      messages.size.should == 1
      messages.first.class.should == WaseEndpoint::Message
    end

    it "should return an empty messages array" do
      mock_twitter_base.should_receive(:replies).and_return([mock_mash(123)])
      @twitterer.fetch.should == []
    end
    
  end

  describe "sending messages" do
    
    before(:all) do
      username ='foo'
      password = 'bar'
      Twitter::HTTPAuth.stub(:new)
      Twitter::Base.stub(:new).and_return(mock_twitter_base)
      
      @time = Time.now
      Time.stub(:now).and_return(@time)

      @twitterer = WaseEndpoint::Twitterer.new(username, password)
    end
    
    it "should send a message with all inputs" do
      mock_twitter_base.should_receive(:update).with("@a #wase, 10, pl_uri, #{@time.utc.to_i}, o_uri, i_uri, i_1_uri")
      @twitterer.send('@a', 10, 'pl_uri', 'o_uri', 'i_uri', 'i_1_uri')
    end
    
    it "should send a message with only one input" do
      mock_twitter_base.should_receive(:update).with("@a #wase, 10, pl_uri, #{@time.utc.to_i}, o_uri, i_uri")
      @twitterer.send('@a', 10, 'pl_uri', 'o_uri', 'i_uri')
    end
    
    it "should send a message with no inputs" do
      mock_twitter_base.should_receive(:update).with("@a #wase, 10, pl_uri, #{@time.utc.to_i}, o_uri")
      @twitterer.send('@a', 10, 'pl_uri', 'o_uri')
    end
    
  end

  def mock_twitter_http_auth
    @auth_mock ||= mock(Twitter::HTTPAuth)
  end
  
  def mock_twitter_base
    @base_mock ||= mock(Twitter::Base)
  end
  
  def mock_mash(message_id)
    mock(Mash, :id => message_id, :text => '@ey-sort #wase, 0, bit.ly/7yQK6, 1256850843, bit.ly/2uhGcl, bit.ly/3kl0xs')
  end
  
end
