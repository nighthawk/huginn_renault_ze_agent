module RenaultZE
  class Client
    API_BASE_URL = 'https://www.services.renault-ze.com/api/'

    def initialize(username, password)
      @username = username
      @password = password
    end

    def login
      response = HTTParty.post(API_BASE_URL + "user/login",
        headers: {"Content-Type": "application/json"}, 
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

      response = HTTParty.get(API_BASE_URL + "/vehicle/#{creds[:vin]}/battery",
        headers: {"Authorization": "Bearer #{creds[:token]}"}
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
