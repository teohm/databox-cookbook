#
# Cookbook Name:: databox
# Recipe:: default
#
#

if node["databox"]["databases"]["mysql"]
  include_recipe "databox::mysql"
end

if node["databox"]["databases"]["postgresql"]
  include_recipe "databox::postgresql"
end
