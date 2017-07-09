task :default do
  chdir 'plugins/web' do
    system 'bundle'
    system 'rake'

    raise 'web tests failed' if $?.exitstatus != 0
  end
end

task :s do
  chdir 'plugins/web' do
    system 'bundle'
    system 'rails s'
  end
end