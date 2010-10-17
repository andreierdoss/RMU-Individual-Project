require 'mongo'
require 'yaml'

module Database
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def connect_db
      config = YAML.load_file("config.yml")
      Mongo::Connection.new.db(config["database"])    
    end
  end

  def connect_db
    self.class.connect_db
  end
end
