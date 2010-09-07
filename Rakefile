require 'rubygems'

require 'system_builder'
require 'system_builder/task'

["#{ENV['HOME']}/.system_builder.rc", "./local.rb"].each do |conf|
  load conf if File.exists?(conf)
end

Dir['tasks/**/*.rake'].each { |t| load t }

SystemBuilder::Task.new(:linkbox) do
  SystemBuilder::DiskSquashfsImage.new("dist/disk").tap do |image|
    image.boot = SystemBuilder::DebianBoot.new("build/root")
    image.boot.configurators << SystemBuilder::PuppetConfigurator.new
  end
end
