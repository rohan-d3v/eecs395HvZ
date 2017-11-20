class CreateZombieReports < ActiveRecord::Migration
  def up
    create_table :zombie_reports do |t|
      t.integer    :game_id
      t.string     :location_lat, :location_long
      t.integer    :num_zombies
      t.datetime   :time_sighted
    end
  end

  def down
    drop_table :zombie_reports
  end
end
