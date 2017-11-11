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
    zombie_report = ZombieReport.find(params[:id])
    render json: Api::V1::ZombieReportSerializer.new(zombie_report).to_json
  end

  api! 'List of zombie reports'
  def index
    zombie_reports = ZombieReport.all
    render(
      json: ActiveModel::ArraySerializer.new(
        zombie_reports,
        each_serializer: Api::V1::ZombieReportSerializer,
        root: 'zombie_reports',
        #meta: meta_attributes(games)
      )
    )
  end
end
