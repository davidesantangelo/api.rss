desc 'Counter cache for project has many entries'

task entry_counter: :environment do
  Feed.reset_column_information
  Feed.all.find_each do |f|
    Feed.reset_counters f.id, :entries
  end
end