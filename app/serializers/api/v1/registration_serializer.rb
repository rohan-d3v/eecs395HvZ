class Api::V1::RegistrationSerializer < Api::V1::BaseSerializer
  attributes :person_id, :game_id, :faction_id, :card_code,
             :score, :is_oz, :wants_oz,
             :is_off_campus, :squad_id,
             :human_type

  has_many :infractions
  has_many :feeds
  has_many :missions#, :class_name => "Attendance"
  #has_many :has_fed#, :foreign_key => "feeder_id"
  has_many :tagged#, :foreign_key => "tagger_id", :class_name => "Tag"
  has_many :taggedby#, :foreign_key => "tagee_id", :class_name => "Tag"
  has_many :check_ins
  has_many :bonus_codes
  has_many :attendances
  has_many :achievements
end
