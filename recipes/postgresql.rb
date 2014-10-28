#
# Cookbook Name:: databox
# Recipe:: postgresql
#
# Install Postgresql and create specified databases and users.
#

root_password = node["databox"]["db_root_password"]
if root_password
  Chef::Log.info %(Set node["postgresql"]["password"]["postgres"] attributes to node["databox"]["db_root_password"])
  node.set["postgresql"]["password"]["postgres"] = root_password
end

include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "database::postgresql"

# Replace the line `local all all ident`
#             with `local all all md5`
node.set['postgresql']['pg_hba'].map! do |line|
  if line[:type] == 'local' && line[:db] == 'all' && line[:user] == 'all' && line[:addr] == nil then
    line[:method] = 'md5'
  end
  line
end

postgresql_connection_info = {
  :host => "localhost",
  :port => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

node["databox"]["databases"]["postgresql"].each do |entry|

  postgresql_database entry["database_name"] do
    connection postgresql_connection_info
    template entry["template"] if entry["template"]
    encoding entry["encoding"] if entry["encoding"]
    collation entry["collation"] if entry["collation"]
    connection_limit entry["connection_limit"] if entry["connection_limit"]
    owner entry["owner"] if entry["owner"]
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
