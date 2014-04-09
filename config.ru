require "./app.rb"
require 'sequel'

#database_url = if !ENV['HEROKU_POSTGRESQL_TEAL_URL'].nil?
#                 ENV['HEROKU_POSTGRESQL_TEAL_URL']
#               elsif !ENV['HEROKU_POSTGRESQL_AQUA_URL'].nil?
#                 ENV['HEROKU_POSTGRESQL_AQUA_URL']
#               else
#                 'postgres://gschool_user:password@localhost/url_shortener_development'
#end
database_url = 'postgres://gschool_user:password@localhost/url_shortener_development'

SQLDB = Sequel.connect(database_url)
DB = URLRepository.new(SQLDB)
run App