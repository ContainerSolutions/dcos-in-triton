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

tf["modules"][0]["resources"].each do |resource_name, resource|
  if resource_name =~ /\-(agent|master|bootstrap)$/
    resource_key = $1
    ip = resource["primary"]["attributes"]["primaryip"]
    inventory[resource_key.to_sym] << ip
  end
end

[:bootstrap, :master, :agent].each do |group|
  hosts = inventory[group]
  hosts.each do |host|
    hostvars = {
      ansible_host: host,
      ansible_port: "22",
      ansible_user: "root",
    }
    hostvars[:bootstrap_host] = inventory[:bootstrap].first unless group == :bootstrap
    inventory[:_meta][:hostvars][host] = hostvars
  end
end

puts inventory.to_json
