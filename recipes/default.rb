#
# Cookbook:: rdp_443
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node.default['rdp']['port'] = 443

puts "Port = #{node['rdp']['port']}"

reboot 'reboot_me' do
  action :nothing
  reason 'Chef required reboot due to configuration change'
  delay_mins 0
end

%w(TCP UDP).each do |protocol|
  firewall_rule_name = "RDP-HTTP-#{protocol}"

  execute 'open-static-port' do
    command "netsh advfirewall firewall add rule name=\"#{firewall_rule_name}\" dir=in action=allow protocol=#{protocol} localport=#{node['rdp']['port']}"
    returns [0, 1, 42] # *sigh* cmd.exe return codes are wonky
    not_if "netsh advfirewall firewall show rule \"#{firewall_rule_name}\""
  end
end

# HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp
# hexadedimal 000001BB
#

registry_key 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' do
  values [{
    name: 'PortNumber',
    type: :dword,
    data: node['rdp']['port'].to_s,
  }]
  action :create
  notifies :request_reboot, 'reboot[reboot_me]', :immediately
end
