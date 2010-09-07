task :clean do
  unless File.exists?("build/root") and system "sudo fuser $PWD/build/root"
    sh "sudo rm -rf build/root"
  end
  sh "rm -f build/*"
  sh "rm -f dist/*"
end
