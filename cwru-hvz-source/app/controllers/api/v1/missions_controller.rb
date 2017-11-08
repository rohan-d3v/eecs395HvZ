class Api::V1::MissionsController < ApplicationController
  #before_filter :check_admin, :except => [ :show, :index ]
  #respond_to :json
  protect_from_forgery with: :null_session
  before_action :destroy_session
  def destroy_session
    request.session_options[:skip] = true
  end

  def show
    mission = Mission.find(params[:id])
    render json: Api::V1::MissionSerializer.new(mission).to_json
  end

  def index
    # if params[:follower_id]
    #   users = User.find(params[:follower_id]).followers
    # elsif params[:following_id]
    #   users = User.find(params[:following_id]).following
    # else
    missions = Mission.all.order(created_at: :asc)
    # end
    # users = apply_filters(users, params)
    # users = paginate(users)
    # users = policy_scope(users)
    render(
      json: ActiveModel::ArraySerializer.new(
        missions,
        each_serializer: Api::V1::MissionSerializer,
        root: 'missions'
        #meta: meta_attributes(users)
      )
    )
  end
end
