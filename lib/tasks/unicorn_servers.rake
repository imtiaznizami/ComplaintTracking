task :development_server do
  # optional port parameter
  port = ENV['PORT'] ? ENV['PORT'] : '3000'
  puts 'start unicorn development'
  # execute unicorn command specifically in development
  # port at 3000 if unspecified
  sh "cd #{Rails.root} && RAILS_ENV=development unicorn -p #{port}"
end

task :production_server do
  # optional port parameter
  port = ENV['PORT'] ? ENV['PORT'] : '3000'
  puts 'start unicorn production'
  # execute unicorn command specifically in production
  # port at 3000 if unspecified
  sh "cd #{Rails.root} && RAILS_ENV=production unicorn -p #{port}"
end

# alias for development_server
task :ds => :development_server

# alias for production_server
task :ps => :production_server