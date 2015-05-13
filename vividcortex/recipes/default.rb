unless node["vividcortex"]["token"] && node["vividcortex"]["token"].size == 32 then
  Chef::Application.fatal!("The 'token' attribute must be set")
end

unless ::File.exists?('/usr/local/bin/vc-agent-007') then
  remote_file '/tmp/vividcortex-install.sh' do
    source 'https://download.vividcortex.com/install'
    mode '0700'
  end

  # The global.conf file will be created during install
  file '/etc/vividcortex/global.conf' do
    action :delete
  end

  execute 'install' do
    command "/tmp/vividcortex-install.sh -s -t #{node['vividcortex']['token']}"
    not_if do ::File.exists?('/usr/local/bin/vc-agent-007') end
  end

end
