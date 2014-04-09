class Migrator
  def initialize(db)
    @db = db
  end

  def run
    Sequel.extension :migration
    migrations_path = File.expand_path("../../../migrations", __FILE__)
    down_migrator = Sequel::IntegerMigrator.new(@db, migrations_path, target: 0)
    down_migrator.run
    up_migrator = Sequel::IntegerMigrator.new(@db, migrations_path)
    up_migrator.run
  end
end