module RenaultZE
  class Client
    def initialize(username, password)
      @username = username
      @password = password
    end

    def login
      response = HTTParty.post(
        "https://www.services.renault-ze.com/api/user/login", 
        body: {username: @username, password: @password}.to_json
      )
      content = JSON.parse response.body
      return {
        token: content["token"],
        vin: content["user"]["vehicle_details"]["VIN"]
      }
    end

    def get_battery(creds)
      response = HTTParty.get(
        "https://www.services.renault-ze.com/api/vehicle/#{creds[:vin]}/battery",
        headers: {"Authorization": "Bearer #{creds["token"]}"}
      )

      result = JSON.parse response.body
      result["last_update"] = result["last_update"] / 1000
      return result
    end
  end
end
