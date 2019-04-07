module RenaultZE
  class Client
    def initialize(username, password)
      @username = username
      @password = password
    end

    def login
      response = HTTParty.post(
        "https://www.services.renault-ze.com/api/user/login",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "User-Agent": "Huginn/2019"
        }, 
        body: {username: @username, password: @password}.to_json
      )
      raise "Login - Unexpected response code: #{response}" unless response.code == 200
      
      content = JSON.parse response.body
      return {
        token: content["token"],
        vin: content["user"]["vehicle_details"]["VIN"]
      }
    end

    def get_battery(creds)
      raise "Battery - Missing token in input: #{creds}" if creds[:token].nil?
      raise "Battery - Missing VIN in input: #{creds}" if creds[:vin].nil?

      response = HTTParty.get(
        "https://www.services.renault-ze.com/api/vehicle/#{creds[:vin]}/battery",
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer #{creds[:token]}",
          "User-Agent": "Huginn/2019"
        }
      )
      raise "Battery - Unexpected response code: #{response}" unless response.code == 200

      result = JSON.parse response.body
      unless result["last_update"].nil?
        epoch = result["last_update"] / 1000
        result["last_update"] = epoch
        result["last_update_hours_ago"] = (Time.now - Time.at(epoch)) / 3600
      end
      return result
    end
  end
end
