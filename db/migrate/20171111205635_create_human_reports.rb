class CreateHumanReports < ActiveRecord::Migration
  def up
    create_table :human_reports do |t|
      t.references :game_id
      t.string     :location_lat, :location_long
      t.integer    :num_humans, :typical_mag_size
      t.datetime   :time_sighted
    end
  end

  def down
    drop_table :human_reports
  end
end
