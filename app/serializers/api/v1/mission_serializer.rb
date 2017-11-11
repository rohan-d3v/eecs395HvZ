class Api::V1::MissionSerializer < Api::V1::BaseSerializer
  attributes :game_id, :start, :end, :description, :winning_faction_id,
             :title, :storyline

  #belongs_to :game
  has_many :attendances
  has_many :feeds
end
