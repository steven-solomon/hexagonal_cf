task :default do
  chdir 'plugins/web' do
    system 'bundle'
    system 'rake db:migrate'
    system 'rake db:test:prepare'
  end

  raise 'tests failed' if %w(plugins/web awesome_scores)
                              .map {|path| run_tests(path)}
                              .any? {|status_code| status_code != 0}
end

def run_tests(path)
  exitstatus = nil
  chdir path do
    system 'rake'
    exitstatus = $?.exitstatus
  end
  exitstatus
end

task :s do
  chdir 'plugins/web' do
    system 'bundle'
    system 'rails s'
  end
end