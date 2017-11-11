class HumanReport < ActiveRecord::Base
  validates :game_id,
            :location_lat, :location_long,
            :time_sighted, :num_humans, :typical_mag_size
            :presence => true

  #attr_accessible :location_lat, :location_long, :num_humans, :typical_mag_size # The user-modifiable fields
end
