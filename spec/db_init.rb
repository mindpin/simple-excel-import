# -*- encoding : utf-8 -*-
require 'mysql2'
require 'active_record'
require 'yaml'

dbconfig = YAML.load_file('spec/dbconfig.yaml')['test']

database = dbconfig.delete('database')

ActiveRecord::Base.establish_connection(dbconfig)

begin
  ActiveRecord::Base.connection.create_database database
rescue ActiveRecord::StatementInvalid => e # database already exists
end

ActiveRecord::Base.establish_connection(dbconfig.merge(:database => database))

ActiveRecord::Migration.verbose = false
