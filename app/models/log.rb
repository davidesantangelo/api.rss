class Log < ApplicationRecord
  belongs_to :feed

  def start!
    self.start_import_at = Time.current

    save!
  end

  def stop!(entries_count: nil)
    self.end_import_at = Time.current
    self.entries_count = entries_count

    save!
  end
end
