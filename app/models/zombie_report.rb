class ZombieReport < ActiveRecord::Base
  validates :game_id,
            :location_lat, :location_long,
            :time_sighted, :num_zombies,
            :presence => true

  #attr_accessible :location_lat, :location_long, :num_zombies, :time_sighted # The user-modifiable fields
end
