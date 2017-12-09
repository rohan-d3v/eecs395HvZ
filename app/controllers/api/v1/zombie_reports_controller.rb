class Api::V1::ZombieReportsController < ApplicationController
  #before_filter :check_admin, :except => [ :show, :index ]
  #respond_to :json
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Apipie::ParamInvalid, with: :invalid_params

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
  param :zombie_report, Hash, :desc => "Zombie report info", :required => true do
    param :game_id, Integer, :desc => "Game id", :required => true
    param :location_lat, String, :desc => "Latitude (decimal)", :required => true
    param :location_long, String, :desc => "Longitude (decimal)", :required => true
    param :time_sighted, String, :desc => "Time sighted (iso date string)", :required => true
    param :num_zombies, Integer, :desc => "Number of zombies in group", :required => true
  end
  def create
    report_params = zombie_report_params
    logger.debug "CREATE zombie report: #{report_params}"
    @report = ZombieReport.create(report_params)
    logger.debug @report
    render json: {database_id: @report.id, success: true}
  end

  api! 'Destroy a zombie report'
  def destroy
    logger.debug "DESTROY zombie report: #{params}"
    @report = ZombieReport.find(params[:id])
    @report.destroy
    render json: {success: true}
  end

  api! 'Update a zombie report'
  param :zombie_report, Hash, :desc => "Zombie report info", :required => true do
    param :game_id, Integer, :desc => "Game id", :required => true
    param :location_lat, String, :desc => "Latitude (decimal)", :required => true
    param :location_long, String, :desc => "Longitude (decimal)", :required => true
    param :time_sighted, String, :desc => "Time sighted (iso date string)", :required => true
    param :num_zombies, Integer, :desc => "Number of zombies in group", :required => true
  end
  def update
    logger.debug "UPDATE zombie report params: #{params}"
    report_params = zombie_report_params
    @report = ZombieReport.find(params[:id])
    logger.debug @report
    @report.update(report_params)
    render json: {success: true}
  end

  private
  def zombie_report_params
    report_params = params.require(:zombie_report).permit(
      :game_id,
      :location_lat, :location_long,
      :time_sighted,
      :num_zombies
    )
    report_params[:game_id] = report_params[:game_id].to_i
    report_params[:location_lat] = report_params[:location_lat].to_d
    report_params[:location_long] = report_params[:location_long].to_d
    report_params[:num_zombies] = report_params[:num_zombies].to_i
    report_params
  end

  def not_found
    respond_to do |format|
      format.html { render file: File.join(Rails.root, 'public', '404.html'), status: 404 }
      format.json { render json: {error: 'not found', sucess: false}, status: 404 }
    end
  end

  def invalid_params
    respond_to do |format|
      format.html { render file: File.join(Rails.root, 'public', '404.html'), status: 400 }
      format.json { render json: {error: 'invalid params', sucess: false}, status: 400 }
    end
  end
end
