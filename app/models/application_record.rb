require 'w3c_validators'
require 'pagy/extras/searchkick'

class ApplicationRecord < ActiveRecord::Base  
  self.abstract_class = true
end
