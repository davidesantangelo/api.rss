class BaseController < ApplicationController
  include Response
  include ExceptionHandler
  include Serializer
  include Pagy::Backend
end