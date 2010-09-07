namespace :buildbot do
  task :dist do
    mkdir_p target_directory = "#{ENV['HOME']}/dist/linkbox"
    cp "dist/disk", "#{target_directory}/disk-#{Time.now.strftime("%Y%m%d-%H%M")}"
  end
end

task :buildbot => [:clean, "linkbox:dist", "buildbot:dist"] do
  # clean in dependencies is executed only once
  Rake::Task["clean"].invoke
end
