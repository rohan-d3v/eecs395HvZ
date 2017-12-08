class Api::V1::HumanReportsController < ApplicationController
  #before_filter :check_admin, :except => [ :show, :index ]
  #before_filter :check_zombie  # auth me pls
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def destroy_session
    request.session_options[:skip] = true
  end

  api! 'A specific human report'
  def show
    @report = HumanReport.find_by!(params[:id])
    render json: Api::V1::HumanReportSerializer.new(@report).to_json
  end

  api! 'List of human reports'
  def index
    @reports = HumanReport.all
    render(
      json: ActiveModel::ArraySerializer.new(
        @reports,
        each_serializer: Api::V1::HumanReportSerializer,
        root: 'human_reports',
        #meta: meta_attributes(games)
      )
    )
  end

  api! 'Create a human report'
  param :human_report, Hash, :desc => "Human report info", :required => true do
    param :game_id, Integer, :desc => "Game id", :required => true
    param :location_lat, String, :desc => "Latitude (decimal)", :required => true
    param :location_long, String, :desc => "Longitude (decimal)", :required => true
    param :time_sighted, String, :desc => "Time sighted (iso date string)", :required => true
    param :num_humans, Integer, :desc => "Number of humans in group", :required => true
    param :typical_mag_size, Integer, :desc => "Typical magazine size", :required => true
  end
  def create
    report_params = human_report_params
    logger.debug "CREATE human report: #{report_params}"
    @report = HumanReport.create(report_params)
    logger.debug @report
    render json: {database_id: @report.id, success: true}
  end

  api! 'Destroy a human report'
  param :id, Integer, :desc => "Database id of report", :required => true
  def destroy
    logger.debug "DESTROY human report params: #{params}"
    @report = HumanReport.find_by!(params[:id])
    @report.destroy
    render json: {success: true}
  end

  api! 'Update a human report'
  param :human_report, Hash, :desc => "Human report info", :required => true do
    param :id, Integer, :desc => "Database id", :required => false
    param :game_id, Integer, :desc => "Game id", :required => true
    param :location_lat, String, :desc => "Latitude (decimal)", :required => true
    param :location_long, String, :desc => "Longitude (decimal)", :required => true
    param :time_sighted, String, :desc => "Time sighted (iso date string)", :required => true
    param :num_humans, Integer, :desc => "Number of humans in group", :required => true
    param :typical_mag_size, Integer, :desc => "Typical magazine size per person", :required => true
  end
  def update
    logger.debug "UPDATE human report params:#{params}"
    if (!params[:human_report].present?)
      raise ActiveRecord::RecordNotFound
    end
    report_params = human_report_params
    if (params[:human_report][:id].present?)
      @report = HumanReport.find_by!(params[:human_report][:id])
    else
      @report = HumanReport.find_by!(report_params)
    end
    logger.debug @report
    @report.update(report_params)
    render json: {database_id: @report.id, success: true}
  end

  private
  def human_report_params
    report_params = params.require(:human_report).permit(
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

  def not_found
    respond_to do |format|
      format.html { render file: File.join(Rails.root, 'public', '404.html'), status: 404 }
      format.json { render json: {error: 'not found', sucess: false}, status: 404 }
    end
  end
end
