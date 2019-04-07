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
      content = service.get_battery(service.login())

      return if memory["last_update"] == content["last_update"]
      memory["last_update"] = content["last_update"]
      create_event payload: content
    end

  end
end
