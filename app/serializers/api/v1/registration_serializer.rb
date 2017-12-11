class Api::V1::RegistrationSerializer < Api::V1::BaseSerializer
  attributes :person_id, :game_id, :faction_id,
             :card_code

  has_many :missions, :class_name => "Attendance"
  #has_many :tagged, :foreign_key => "tagger_id", :class_name => "Tag"
  #has_many :taggedby, :foreign_key => "tagee_id", :class_name => "Tag"
end
