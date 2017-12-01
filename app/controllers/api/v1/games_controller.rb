class Api::V1::GamesController < ApplicationController
  before_filter :check_admin, :except => [ :show, :index ]
  #respond_to :json
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  api! 'A specific game'
  def show
    game = Game.find(params[:id])
    render json: Api::V1::GameSerializer.new(game).to_json
  end

  api! 'List of games'
  def index
    games = Game.all
    render(
      json: ActiveModel::ArraySerializer.new(
        games,
        each_serializer: Api::V1::GameSerializer,
        root: 'games',
        #meta: meta_attributes(games)
      )
    )
  end
end
