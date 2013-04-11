require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

SystemBuilder::BoxTasks.new(:linkbox) do |box|
  box.boot do |boot|
    boot.version = :squeeze
  end

  box.disk_image do |image|
    image.size = 4000.megabytes
  end
end

desc "Run continuous integration tasks (spec, ...)"
task :ci => "linkbox:buildbot"
