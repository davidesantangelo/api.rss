class EntrySerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :body
end
