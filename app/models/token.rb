class Token < ApplicationRecord
  # callbacks
  before_create :generate_key

  # scopes
  scope :active, -> { where(active: :true).where("expires_at IS NULL OR expires_at >= ?", Time.current) }
  scope :expired, -> { where.not(expires_at: nil).where("expires_at < ?", Time.current) }

  def self.expire!
    expired.update_all(active: false)
  end

  protected

  def generate_key
    self.key = loop do
      random_key = SecureRandom.urlsafe_base64(64)
      break random_key unless Token.exists?(key: random_key)
    end
  end
end
