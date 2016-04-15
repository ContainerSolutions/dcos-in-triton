#!/usr/bin/env ruby

require "json"

tf = JSON.load(File.open("terraform.tfstate"))
raise "no modules in input file" if !tf["modules"] || tf["modules"].empty?

inventory = {
  bootstrap: [],
  master:    [],
  agent:     [],
  _meta:     {
    hostvars: {}
  }
}

grouped_machines = tf["modules"][0]["resources"].map do |name, resource|
  next unless name =~ /^triton_machine/
  attrs = resource["primary"]["attributes"]
  OpenStruct.new({
    name:      attrs["name"],
    group:     attrs["tags.role"].to_sym,
    privateip: attrs["ips.1"],
    publicip:  attrs["primaryip"]
  })
end.compact.group_by { |m| m.group }


grouped_machines.each do |group, machines|
  inventory[group] = machines.map { |m| m.publicip }

  machines.each do |m|
    hostvars = {
      ansible_host:   m.publicip,
      ansible_port:   "22",
      ansible_user:   "root",
      bootstrap_host: grouped_machines[:bootstrap].first.privateip,
      name:           m.name
    }

    if m.group == :bootstrap
      hostvars[:masters] = grouped_machines[:master].map { |m| m.privateip }
      hostvars[:agents]  = grouped_machines[:agent].map { |m| m.privateip }
    end

    inventory[:_meta][:hostvars][m.publicip] = hostvars
  end
end

puts inventory.to_json
