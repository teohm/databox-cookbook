#
# Cookbook Name:: databox
# Recipe:: postgresql
#
# Install Postgresql and create specified databases and users.
#

root_password = node["databox"]["root_password"]
if root_password
  Chef::Log.warn %(Set node["postgresql"]["password"]["postgres"] attributes to node["databox"]["root_password"])
  node.set["postgresql"]["password"]["postgres"] = root_password
end

include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "database::postgresql"

#TODO Chef 11 compat?
node.set['postgresql']['pg_hba'] = [
  {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
  {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'}
]


postgresql_connection_info = {
  :host => "localhost",
  :port => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

node["databox"]["databases"]["postgresql"].each do |entry|

  postgresql_database entry["database_name"] do
    connection postgresql_connection_info
    action :create
  end

  postgresql_database_user entry["username"] do
    connection postgresql_connection_info
    action [:create, :grant]
    password(entry["password"])           if entry["password"]
    database_name(entry["database_name"]) if entry["database_name"]
    privileges(entry["privileges"])       if entry["privileges"]
  end

end
