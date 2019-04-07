module Agents
  class RenaultZeBatteryAgent < Agent
    include FormConfigurable

    default_schedule 'every_5h'

    cannot_receive_events!

    description <<-MD
      The Renault ZE Battery Agent checks the battery status of your Renault.

      To authenticate you need to either set the `username` and `password`, or
      provide credentials named `renault_ze_username` and `renault_ze_password`.
    MD

    event_description <<-MD
      Events look like this:

      ```json
      {
        "charge_level": 40, 
        "charging": false, 
        "plugged": false,
        "remaining_range": 115.0,
        "last_update": 1554572276, 
        "last_update_hours_ago": 5.12
      }
      ```
    MD

    def default_options
      {
        "username" => "",
        "password" => ""
      }
    end

    form_configurable :username
    form_configurable :password

    def validate_options
      errors.add(:base, "you need to specify your Renault ZE username or provide a credential names renault_ze_username") unless options["username"].present? || credential("renault_ze_username").present?
      errors.add(:base, "you need to specify your Renault ZE password or provide a credential names renault_ze_password") unless options["password"].present? || credential("renault_ze_password").present?
    end

    def working?
      checked_without_error?
    end

    def check
      username = interpolated["username"].present? ? interpolated["username"] : credential("renault_ze_username")
      password = interpolated["password"].present? ? interpolated["password"] : credential("renault_ze_password")
      service = RenaultZE::Client.new(username, password)

      begin
        content = service.get_battery(service.login())
      rescue
        error("Could not fetch battery level: " + $!)
        raise
      end

      if memory["last_update"] != content["last_update"]
        created_event = create_event payload: content

        log("Creating new event as newer data received, updated #{content["last_update_hours_ago"]}h ago.", :outbound_event => created_event)
        memory["last_update"] = content["last_update"]
      else
        log("Not creating event as no update since last run. Last update was #{content["last_update_hours_ago"]}h ago.")
      end
    end

  end
end
