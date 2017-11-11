# documentation for serializers at https://github.com/rails-api/active_model_serializers/tree/0-9-stable

class Api::V1::BaseSerializer < ActiveModel::Serializer
  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end
