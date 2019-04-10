namespace :importer do
  desc "import feeds"
  task run: :environment do
    Importer.run
  end
end
