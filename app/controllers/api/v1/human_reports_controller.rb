class Api::V1::HumanReportsController < Api::V1::BaseController
  #before_filter :check_admin, :except => [ :show, :index ]
  #before_filter :check_zombie  # auth me pls
  resource_description do
    name 'Human Reports'
    short 'Reports submitted about humans'
    formats ['json']
    error 404, "Could not find resource. Will respond with {error: 'not found', success: false}"
    error 400, "Invalid parameters. Will responsd with {error: 'invalid params', success: false}"
  end

  def_param_group :human_report do
    param :human_report, Hash, :desc => "Human report info", :required => true do
      param :game_id, Integer, :desc => "Game id", :action_aware => true
      param :location_lat, String, :desc => "Latitude (decimal)", :action_aware => true
      param :location_long, String, :desc => "Longitude (decimal)", :action_aware => true
      param :time_sighted, String, :desc => "Time sighted (iso date string)", :action_aware => true
      param :num_humans, Integer, :desc => "Number of humans in group", :action_aware => true
      param :typical_mag_size, Integer, :desc => "Typical magazine size", :action_aware => true
    end
  end


  api! 'A specific human report'
  meta 'human_report' => {
    'id' => "the database id of the report",
    'game_id' => "the id of the game this was reported for",
    'location_lat' => "latitude (decimal)",
    'location_long' => "longitude (decimal)",
    'time_sighted' => "time of report (iso 8601)",
    'num_humans' => "number of humans",
    'typical_mag_size' => "typical magazine size (int)"
  }
  example <<-EOS
  { "human_report":
    {
      "id": 1,
      "game_id": 1,
      "location_lat": "41.501286999999",
      "location_long": "-81.60334699999",
      "time_sighted":"2017-12-01T03:10:10.548-05:00",
      "num_humans": 4,
      "typical_mag_size": 8
    }
  }
  EOS
  def show
    @report = HumanReport.find(params[:id])
    render json: Api::V1::HumanReportSerializer.new(@report).to_json
  end


  api! 'List of human reports'
  meta 'human_report' => {
    'id' => "the database id of the report",
    'game_id' => "the id of the game this was reported for",
    'location_lat' => "latitude (decimal)",
    'location_long' => "longitude (decimal)",
    'time_sighted' => "time of report (iso 8601)",
    'num_humans' => "number of humans",
    'typical_mag_size' => "typical magazine size (int)"
  }
  example <<-EOS
  { "human_reports":
    [
      {"id":1,"game_id":1,"location_lat":"41.5012869999","location_long":"-81.60334699","time_sighted":"2017-12-01T03:10:10.548-05:00","num_humans":4,"typical_mag_size":11},
      {"id":3,"game_id":1,"location_lat":"41.501763049386064","location_long":"-81.61213763058184","time_sighted":"2017-12-08T17:52:14.678-05:00","num_humans":22,"typical_mag_size":4}
    ]
  }
  EOS
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
  see "human_reports#show", "Format of a human report"
  meta 'human_report' => {
    'game_id' => "the id of the game this was reported for",
    'location_lat' => "latitude (decimal)",
    'location_long' => "longitude (decimal)",
    'time_sighted' => "time of report (iso 8601)",
    'num_humans' => "number of humans",
    'typical_mag_size' => "typical magazine size (int)"
  }
  param_group :human_report, :as => :create
  example <<-EOS
  { "database_id": 4, "success": true }
  EOS
  def create
    report_params = human_report_params
    logger.debug "CREATE human report: #{report_params}"
    @report = HumanReport.create(report_params)
    logger.debug @report
    render json: {database_id: @report.id, success: true}
  end


  api! 'Destroy a human report'
  meta 'id' => 'the database id of the report'
  example <<-EOS
  { "success": true }
  EOS
  def destroy
    logger.debug "DESTROY human report params: #{params}"
    @report = HumanReport.find(params[:id])
    @report.destroy
    render json: {success: true}
  end


  api! 'Update a human report'
  meta 'human_report' => {
    'id' => "the database id of the report",
    'game_id' => "the id of the game this was reported for",
    'location_lat' => "latitude (decimal)",
    'location_long' => "longitude (decimal)",
    'time_sighted' => "time of report (iso 8601)",
    'num_humans' => "number of humans",
    'typical_mag_size' => "typical magazine size (int)"
  }
  see "human_reports#show", "Format of a human report"
  param_group :human_report, :as => :update
  example <<-EOS
  { "success": true }
  EOS
  def update
    logger.debug "UPDATE human report params: #{params}"
    report_params = human_report_params
    @report = HumanReport.find(params[:id])
    logger.debug @report
    @report.update(report_params)
    render json: {success: true}
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
end
