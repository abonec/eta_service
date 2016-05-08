require 'json'
module Helpers
  def response_json
    JSON.parse last_response.body
  end
  def test_cabs_file
    File.expand_path(File.join(File.dirname(__FILE__), 'test_cabs.txt'))
  end
  def load_data
    App::Cab.load_data(test_cabs_file)
    sleep 1
  end
end