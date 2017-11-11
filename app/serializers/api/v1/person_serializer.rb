class Api::V1::PersonSerializer < Api::V1::BaseSerializer
  attributes :name, :caseid, :last_login,
             :is_admin,

  has_many :infractions # Infractions submitted by this admin
  has_many :registrations
  has_many :waivers
end
