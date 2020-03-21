require 'net/http'

module HttpClient
  def self.assert_200(url)
    resp = Net::HTTP.get_response(URI(url))
    unless resp.code == "200"
      raise "Expected status 200 for #{url}, got #{resp.inspect}"
    end
  end
end
