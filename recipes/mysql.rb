#
# Cookbook Name:: databox
# Recipe:: mysql
#
# Install MySQL and create specified databases and users.
#

root_password = node["databox"]["db_root_password"]
if root_password
  Chef::Log.info %(Set mysql.server_*_password attributes to node["databox"]["db_root_password"])
  node.set["mysql"]["server_root_password"] = root_password
  node.set["mysql"]["server_repl_password"] = root_password
  node.set["mysql"]["server_debian_password"] = root_password
end

include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "database::mysql"

mysql_connection_info = {
  :host => "localhost",
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

node["databox"]["databases"]["mysql"].each do |entry|

  mysql_database entry["database_name"] do
    connection mysql_connection_info
    encoding entry["encoding"] if entry["encoding"]
    collation entry["collation"] if entry["collation"]
    action :create
  end

  mysql_database_user entry["username"] do
    connection mysql_connection_info
    action [:create, :grant]
    password(entry["password"])           if entry["password"]
    database_name(entry["database_name"]) if entry["database_name"]
    privileges(entry["privileges"])       if entry["privileges"]
    host(entry["host"])                   if entry["host"]
    table(entry["table"])                 if entry["table"]
  end

end
