# frozen_string_literal: true

class IpWhitelist < ApplicationRecord
  require 'resolv'

  # validations
  validates :ip_address, presence: true, uniqueness: true, format: { with: Resolv::IPv4::Regex }

  def self.enabled?(ip_address:)
    find_by(ip_address: ip_address).present?
  end

  def self.add(ip_address:)
    find_or_create_by(ip_address: ip_address)
  end

  def self.remove(ip_address:)
    ip_whitelist = find_by(ip_address: ip_address)
    ip_whitelist&.delete
  end
end
