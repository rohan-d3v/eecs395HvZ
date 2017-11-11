class Api::V1::MissionsController < ApplicationController
  before_filter :check_admin, :except => [ :show, :index ]
  protect_from_forgery with: :null_session
  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  api! 'A specific mission'
  def show
    mission = Mission.find(params[:id])
    render json: Api::V1::MissionSerializer.new(mission).to_json
  end

  api! 'List of missions'
  def index
    missions = Mission.all
    render(
      json: ActiveModel::ArraySerializer.new(
        missions,
        each_serializer: Api::V1::MissionSerializer,
        root: 'missions',
        #meta: meta_attributes(missions)
      )
    )
  end
end
