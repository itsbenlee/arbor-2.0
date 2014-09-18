task :setup_task, :project_name do |t, args|
  p 'Please provide a name for your app: rake setup_task[project_name]' and exit unless args[:project_name]

  project_name = args[:project_name]
  file_names   = [
    'app/views/layouts/application.html.haml',
    'config/application.rb',
    'config/environment.rb',
    'config/environments/development.rb',
    'config/environments/production.rb',
    'config/environments/test.rb',
    'config/initializers/secret_token.rb',
    'config/initializers/session_store.rb',
    'config/routes.rb',
    'Rakefile'
  ]

  module_name = project_name.split('_').each(&:capitalize!).join

  file_names.each do |file_name|
    p "Renaming Railsroot module to #{module_name} on #{file_name}"
    file_content     = File.read(file_name)
    replaced_content = file_content.gsub(/Railsroot/, module_name)
    File.open(file_name, "w") { |file| file.write(replaced_content) }
  end
end
