ENV['RACK_ENV'] = 'test'
require 'sequel'

SQLDB = Sequel.connect('postgres://gschool_user:password@localhost/url_shortener_test')

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

def id_of_created_url(current_path)
  current_path.gsub('/', '')
end
