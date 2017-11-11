class Api::V1::ZombieReportsController < ApplicationController
  before_filter :check_admin, :except => [ :show, :index ]
  #respond_to :json
  protect_from_forgery with: :null_session
  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  api! 'A specific zombie report'
  def show
    @zombie_report = ZombieReport.find(params[:id])
    render json: Api::V1::ZombieReportSerializer.new(@zombie_report).to_json
  end

  api! 'List of zombie reports'
  def index
    @zombie_reports = ZombieReport.all
    render(
      json: ActiveModel::ArraySerializer.new(
        @zombie_reports,
        each_serializer: Api::V1::ZombieReportSerializer,
        root: 'zombie_reports',
        #meta: meta_attributes(@zombie_reports)
      )
    )
  end

  api! 'Create a zombie report'
  param :zombie_report, Hash, :desc => "Zombie report info" do
    param :game_id, String, :desc => "Game id", :required => true
    param :location_lat, String, :desc => "Latitude", :required => true
    param :location_long, String, :desc => "Longitude", :required => true
    param :time_sighted, String, :desc => "Time sighted", :required => true
    param :num_zombies, Integer, :desc => "Number of zombies in group", :required => true
  end
  def create
    @zombie_report = ZombieReport.new(zombie_report_params)
  end

  api! 'Destroy a zombie report'
  def destroy
    @zombie_report = ZombieReport.find(params[:id])
    @zombie_report.destroy
    head :no_content
  end

  private
  def zombie_report_params
    params.require(:zombie_report).permit(
      :game_id,
      :location_lat, :location_long,
      :time_sighted, :num_zombies
    )
  end
end
