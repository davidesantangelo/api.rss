class Token < ApplicationRecord
  before_create :generate_key

  # scopes
  scope :active, -> { where(active: :true).where("expires_at IS NULL OR expires_at >= ?", Time.current) }

  protected

  def generate_key
    self.key = loop do
      random_key = SecureRandom.urlsafe_base64(64)
      break random_key unless Token.exists?(key: random_key)
    end
  end
end
