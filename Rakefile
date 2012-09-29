require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

SystemBuilder::BoxTasks.new(:linkbox) do |box|
  box.disk_image do |image|
    image.size = 500.megabytes
  end
end

desc "Run continuous integration tasks (spec, ...)"
task :ci => "linkbox:buildbot"
