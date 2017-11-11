class Api::V1::PersonSerializer < Api::V1::BaseSerializer
  attributes :name, :caseid, :last_login,
             :is_admin

  has_many :infractions
  has_many :registrations
  has_many :waivers

  def filter(keys)
    keys.delete :infractions unless object.is_admin
    keys
  end
end
