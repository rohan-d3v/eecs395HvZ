class CreateZombieReports < ActiveRecord::Migration
  def up
    create_table :zombie_reports do |t|
      t.references :game
      t.decimal    :location_lat, :location_long
      t.integer    :num_zombies
      t.datetime   :time_sighted
    end
  end

  def down
    drop_table :zombie_reports
  end
end
