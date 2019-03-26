class TokenSerializer
  include FastJsonapi::ObjectSerializer
  attributes :key, :expires_at, :active

  attribute :expires_at do |object|
    object.expires_at.to_i
  end
end
