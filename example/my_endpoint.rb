require 'rubygems'
require 'wase_endpoint'

class MyEndpoint < WaseEndpoint
  
  # This where our logic goes.
  # A json encoded String is the only argument. You can deal with this however
  # you want. The JSON library is already loaded should you wish to use it.
  # Return another String, or a Hash containing the String and the program
  # counter increment you wish to use.
  def secret_sauce(raw_json)
  
    # Just pass it back. Program counter increment will be 1.
    raw_json
    
    # Or pass it back with a custom program counter.
    # { :data => raw_json, :increment => 2}
  end
  
end
