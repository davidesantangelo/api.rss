# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IpWhitelist, type: :model do
  it 'ensures ip_address presence' do
    ip_whitelist = IpWhitelist.new.save
    expect(ip_whitelist).to eq(false)
  end
end
