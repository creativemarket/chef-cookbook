unless node["vividcortex"]["token"] && node["vividcortex"]["token"].size == 32 then
  Chef::Application.fatal!("The 'token' attribute must be set")
end

unless ::File.exists?('/usr/local/bin/vc-agent-007') then

  install_script = "#{Chef::Config['file_cache_path']}/vividcortex-install.sh"

  remote_file install_script do
    source node["vividcortex"]["download"]
    mode '0700'
  end

  # The global.conf file will be created during install
  file '/etc/vividcortex/global.conf' do
    action :delete
  end

  execute 'install' do
    command "#{install_script} -s -t #{node['vividcortex']['token']}"
    not_if do ::File.exists?('/usr/local/bin/vc-agent-007') end
  end

end
