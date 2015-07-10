#
# Cookbook Name:: databox
# Recipe:: default
#
#

if node["databox"]["databases"]["mysql"].any?
  include_recipe "databox::mysql"
end

if node["databox"]["databases"]["postgresql"].any?
  include_recipe "databox::postgresql"
end
