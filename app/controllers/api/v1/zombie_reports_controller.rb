class Api::V1::ZombieReportsController < Api::V1::BaseController
  #before_filter :check_admin, :except => [ :show, :index ]
  #before_filter :check_human  # auth me pls
  resource_description do
    name 'Zombie Reports'
    short 'Reports submitted about zombies'
    formats ['json']
    error 404, "Could not find resource. Will respond with {error: 'not found', success: false}"
    error 400, "Invalid parameters. Will responsd with {error: 'invalid params', success: false}"
  end

  def_param_group :zombie_report do
    param :zombie_report, Hash, :desc => "Zombie report info", :required => true do
      param :game_id, Integer, :desc => "Game id", :action_aware => true
      param :location_lat, String, :desc => "Latitude (decimal)", :action_aware => true
      param :location_long, String, :desc => "Longitude (decimal)", :action_aware => true
      param :time_sighted, String, :desc => "Time sighted (iso date string)", :action_aware => true
      param :num_zombies, Integer, :desc => "Number of zombies in group", :action_aware => true
    end
  end


  api! 'A specific zombie report'
  meta 'id' => 'the database id of the report'
  example <<-EOS
  {
    "id": 97,
    "game_id": 1,
    "location_lat": "41.50355035549572",
    "location_long": "-81.6086383536458",
    "time_sighted": "2017-12-07T02:50:27.323-05:00",
    "num_zombies": 22
  }
  EOS
  def show
    @zombie_report = ZombieReport.find(params[:id])
    render json: Api::V1::ZombieReportSerializer.new(@zombie_report).to_json
  end


  api! 'List of zombie reports'
  meta 'id' => 'the database id of the report'
  example <<-EOS
  { "zombie_reports":
    [
      {"id":121,"game_id":1,"location_lat":"41.50615288427887","location_long":"-81.60221144556999","time_sighted":"2017-12-08T17:18:17.361-05:00","num_zombies":4551},
      {"id":97,"game_id":1,"location_lat":"41.50355035549572","location_long":"-81.6086383536458","time_sighted":"2017-12-07T02:50:27.323-05:00","num_zombies":22},
      {"id":105,"game_id":1,"location_lat":"41.504163020021174","location_long":"-81.60728048533203","time_sighted":"2017-12-07T03:12:48.757-05:00","num_zombies":23},
    ]
  }
  EOS
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
  see "zombie_reports#show", "Format of a zombie report"
  param_group :zombie_report, :as => :create
  example <<-EOS
  { "database_id": 4, "success": true }
  EOS
  def create
    report_params = zombie_report_params
    logger.debug "CREATE zombie report: #{report_params}"
    @report = ZombieReport.create(report_params)
    logger.debug @report
    render json: {database_id: @report.id, success: true}
  end


  api! 'Destroy a zombie report'
  meta 'id' => 'the database id of the report'
  example <<-EOS
  { "success": true }
  EOS
  def destroy
    logger.debug "DESTROY zombie report: #{params}"
    @report = ZombieReport.find(params[:id])
    @report.destroy
    render json: {success: true}
  end


  api! 'Update a zombie report'
  meta 'id' => 'the database id of the report'
  param_group :zombie_report, :as => :update
  see "zombie_reports#show", "Format of a zombie report"
  example <<-EOS
  { "success": true }
  EOS
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
end
