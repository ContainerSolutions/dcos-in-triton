require 'json'
tf_file = ARGV[0]

tf = JSON.load(File.open(tf_file))
raise 'no modules in input file' if !tf['modules'] || tf['modules'].empty?

ips = {'bootstrap' => [], 'master' => [], 'agent' => []}
tf['modules'][0]['resources'].each do |resource_name, resource|
  if resource_name =~ /\-(agent|master|bootstrap)$/
    ip_index = resource['primary']['attributes']['ips.#'].to_i - 1
    raise "#{resource_name} has no IPs!" if ip_index < 0
    ips[$1] << resource['primary']['attributes']["ips.#{ip_index}"]
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
