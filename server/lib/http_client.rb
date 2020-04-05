require 'net/http'

module HttpClient
  def self.assert_200(url)
    max_seconds = 5
    attempts = 20
    attempts.times do |i|
      begin
        resp = Net::HTTP.get_response(URI(url))
        return if resp.code == "200"
      rescue Errno::ECONNREFUSED
        nil
      end
      sleep max_seconds.to_f / attempts
    end

    resp = Net::HTTP.get_response(URI(url))
    return if resp.code == "200"
    raise "Expected status 200 for #{url}, got #{resp.code}\n\n#{resp.inspect}"
  end
end
