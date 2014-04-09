require "./app.rb"
require 'sequel'

database_url = if !ENV['HEROKU_POSTGRESQL_ROSE_URL'].nil?
                 ENV['HEROKU_POSTGRESQL_ROSE_URL']
               else
                 'postgres://gschool_user:password@localhost/url_shortener_development'
end
SQLDB = Sequel.connect(database_url)
DB = URLRepository.new(SQLDB)
run App