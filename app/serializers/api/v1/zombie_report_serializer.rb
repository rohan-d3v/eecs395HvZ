class Api::V1::ZombieReportSerializer < Api::V1::BaseSerializer
  attributes :id, :game_id,
             :location_lat, :location_long,
             :time_sighted,
             :num_zombies
end
