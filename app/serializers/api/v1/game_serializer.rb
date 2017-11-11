class Api::V1::GameSerializer < Api::V1::BaseSerializer
  attributes :game_begins, :game_ends,
             :is_current, :information, :rules

  has_many :registrations
  has_many :tags
  has_many :missions
  has_many :waivers
  has_many :contact_messages
  has_many :squads
#  has_many :ozs, -> { where is_oz: true }, class_name: 'Registration'
  has_many :ozs
  has_many :bonus_codes
end
