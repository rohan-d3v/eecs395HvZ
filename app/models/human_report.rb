class HumanReport < ActiveRecord::Base
  belongs_to :game
  validates :location_lat, :location_long,
            :time_sighted, :num_humans, :typical_mag_size,
            :presence => true

  #attr_accessible :location_lat, :location_long, :num_humans, :typical_mag_size, :time_sighted # The user-modifiable fields
end
