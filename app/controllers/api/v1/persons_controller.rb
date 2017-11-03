class Api::V1::PeopleController < ApplicationController
  before_filter :check_admin, :except => [ :show, :index ]
  #respond_to :json
  protect_from_forgery with: :null_session
  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  def show
    people = People.find(params[:id])
    render json: Api::V1::PeopleSerializer.new(people).to_json
  end

  def index
    # if params[:follower_id]
    #   users = User.find(params[:follower_id]).followers
    # elsif params[:following_id]
    #   users = User.find(params[:following_id]).following
    # else
    people = People.all.order(created_at: :asc)
    # end
    # users = apply_filters(users, params)
    # users = paginate(users)
    # users = policy_scope(users)
    render(
      json: ActiveModel::ArraySerializer.new(
        people,
        #each_serializer: Api::V1::MissionSerializer,
        root: 'people',
        #meta: meta_attributes(missions)
      )
    )
  end
end
