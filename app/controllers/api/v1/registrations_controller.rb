class Api::V1::RegistrationsController < ApplicationController
  before_filter :check_admin, :except => [ :show, :index ]
  #respond_to :json
  protect_from_forgery with: :null_session
  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  def show
    registration = Registration.find(params[:id])
    render json: Api::V1::RegistrationSerializer.new(registration).to_json
  end

  def index
    registrations = Registration.all.order(created_at: :asc)
    render(
      json: ActiveModel::ArraySerializer.new(
        registrations,
        each_serializer: Api::V1::RegistrationSerializer,
        root: 'registrations',
        #meta: meta_attributes(games)
      )
    )
  end
end
