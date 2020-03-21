require_relative './shell'

module Systemd
  def self.assert_running(unit)
    raise "Systemd unit #{unit} is not in running state" unless running?(unit)
  end

  def self.running?(unit)
    properties = get_unit_properties(unit, [:ActiveState, :SubState])
    properties == {
      ActiveState: "active",
      SubState: "running",
    }
  end

  private_class_method def self.get_unit_properties(unit, properties)
    properties.map do |property|
      [property, get_unit_property(unit, property)]
    end.to_h
  end

  private_class_method def self.get_unit_property(unit, property)
    Shell.exec("systemctl show #{unit} --property=#{property}")
      .delete_prefix!(property.to_s)
      .delete_prefix!("=")
  end
end
