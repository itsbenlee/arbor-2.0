task :code_analysis do
  sh 'bundle exec reek app config lib'
end
