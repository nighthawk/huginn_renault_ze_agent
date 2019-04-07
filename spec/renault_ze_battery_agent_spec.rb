require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::RenaultZeBatteryAgent do
  before(:each) do
    @valid_options = {
      "username" => "some_username",
      "password" => "some_password"
    }
    @checker = Agents::RenaultZeBatteryAgent.new(:name => "RenaultZeBatteryAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.memory = {}
    @checker.save!
  end

  describe "#validate_options" do
    before do
      expect(@checker).to be_valid
    end

    it "should reject an empty username" do
      @checker.options["username"] = nil
      expect(@checker).not_to be_valid
    end

    it "should reject an empty password" do
      @checker.options["password"] = nil
      expect(@checker).not_to be_valid
    end

    it "should allow credentials (instead of providing as options)" do
      @checker.user.user_credentials.create :credential_name => "renault_ze_username", :credential_value => "some_username"
      @checker.user.user_credentials.create :credential_name => "renault_ze_password", :credential_value => "some_password"
      @checker.options["username"] = nil
      @checker.options["password"] = nil
      expect(@checker).to be_valid
    end
  end

  describe "#check" do
    before do
      stub_login = {"token": "some_token", "user": {"vehicle_details": {"VIN": "some_vin"}}}
      stub_battery = {"charge_level": 40, "charging": false, "last_update": 1554572276000, "remaining_range": 115.0}

      stub_request(:post, "https://www.services.renault-ze.com/api/user/login")
        .to_return(:status => 200, :body => JSON.dump(stub_login), :headers => {})
      
      stub_request(:get, "https://www.services.renault-ze.com/api/vehicle/some_vin/battery")
        .to_return(:status => 200, :body => JSON.dump(stub_battery), :headers => {})
    end

    it "should execute the query and emit a new event with battery status" do
      expect { @checker.check }.to change {Event.count}.by(1)

      event = Event.last
      expect(event.payload['charge_level']).to eq(40)
      expect(event.payload['charging']).to eq(false)
      expect(event.payload['last_update']).to eq(1554572276) # sic
      expect(event.payload['remaining_range']).to eq(115)
    end

    it "shouldn't emit the same status again if the timestamp didn't change"  do
      expect { @checker.check }.to change {Event.count}.by(1)
      expect { @checker.check }.to change {Event.count}.by(0)
    end
  end
end
