class Api::V1::HumanReportsController < ApplicationController
  #before_filter :check_admin, :except => [ :show, :index ]
  #before_filter :check_zombie  # auth me pls
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  api! 'A specific human report'
  def show
    @human_report = HumanReport.find(params[:id])
    render json: Api::V1::HumanReportSerializer.new(@human_report).to_json
  end

  api! 'List of human reports'
  def index
    @human_reports = HumanReport.all
    render(
      json: ActiveModel::ArraySerializer.new(
        @human_reports,
        each_serializer: Api::V1::HumanReportSerializer,
        root: 'human_reports',
        #meta: meta_attributes(games)
      )
    )
  end

  api! 'Create a human report'
  param :human_report, Hash, :desc => "Human report info" do
    param :game_id, Integer, :desc => "Game id", :required => true
    param :location_lat, String, :desc => "Latitude (decimal)", :required => true
    param :location_long, String, :desc => "Longitude (decimal)", :required => true
    param :time_sighted, String, :desc => "Time sighted (iso date string)", :required => true
    param :num_humans, Integer, :desc => "Number of humans in group", :required => true
    param :typical_mag_size, Integer, :desc => "Typical magazine size", :required => true
  end
  def create
    report_params = human_report_params
    logger.debug "CREATE human report: [#{report_params.class}] #{report_params}"
    logger.debug report_params.inspect
    @human_report = HumanReport.new(report_params)
  end

  api! 'Destroy a human report'
  def destroy
    @human_report = HumanReport.find(params[:id])
    @human_report.destroy
    head :no_content
  end

  private
  def human_report_params
    report_params = params.require(:zombie_report).permit(
      :game_id,
      :location_lat, :location_long,
      :time_sighted,
      :num_humans, :typical_mag_size
    )
    report_params[:game_id] = report_params[:game_id].to_i
    report_params[:location_lat] = report_params[:location_lat].to_d
    report_params[:location_long] = report_params[:location_long].to_d
    report_params[:num_humans] = report_params[:num_humans].to_i
    report_params[:typical_mag_size] = report_params[:typical_mag_size].to_i
    report_params
  end
end
