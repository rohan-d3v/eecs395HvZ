class Api::V1::PersonSerializer < Api::V1::BaseSerializer
  attributes :id, :created_at, :updated_at,
             :name, :caseid, :picture, :phone, :last_login,
             :is_admin,  :date_of_birth

  has_many :infractions # Infractions submitted by this admin
  has_many :registrations
  has_many :waivers
end
