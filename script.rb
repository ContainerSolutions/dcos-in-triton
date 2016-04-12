require 'json'
tf_file = ARGV[0]

tf = JSON.load(File.open(tf_file))
raise 'no modules in input file' if !tf['modules'] || tf['modules'].empty?
IP_PATTERN = /^10\./

ips = {'bootstrap' => [], 'master' => [], 'agent' => []}
tf['modules'][0]['resources'].each do |resource_name, resource|
  if resource_name =~ /\-(agent|master|bootstrap)$/
    resource_key = $1
    ip_count = resource['primary']['attributes']['ips.#'].to_i
    ip_count.times do |i|
      ip = resource['primary']['attributes']["ips.#{i}"]
      if ip =~ IP_PATTERN
        ips[resource_key] << ip
        break
      end
    end
  end
end

output = ips.merge({
  '_meta' => {
    'hostvars' => {
      ips['master'][0] => {
        'ansible_host' => ips['master'][0],
        'ansible_port' => '22',
        'ansible_user' => 'root',
        'bootstrap_ip' => ips['bootstrap'][0]
      }
    }
  }
})
puts JSON.pretty_generate(output)
