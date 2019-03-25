require 'pagy/extras/elasticsearch_rails'
require 'pagy/extras/headers'

class ApplicationController < ActionController::API
  include ::ActionController::Cookies

  Pagy::VARS[:headers] = {page: 'Current-Page', items: 'Per-Page', pages: false, count: 'Total'}

  def render(*args, &block)
    pagy_headers_merge(@pagy) if @pagy
    super
  end
end
