class Api::V1::HumanReportSerializer < Api::V1::BaseSerializer
  attributes :game_id,
             :location_lat, :location_long,
             :time_sighted,
             :num_humans, :typical_mag_size
end
