class EntrySerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :body
end
