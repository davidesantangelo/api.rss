require 'w3c_validators'
require 'pagy/extras/elasticsearch_rails'

class ApplicationRecord < ActiveRecord::Base  
  self.abstract_class = true
end
