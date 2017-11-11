class Api::V1::HumanReportsController < ApplicationController
  before_filter :check_admin, :except => [ :show, :index ]
  #respond_to :json
  protect_from_forgery with: :null_session
  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  api! 'A specific human report'
  def show
    human_report = HumanReport.find(params[:id])
    render json: Api::V1::HumanReportSerializer.new(human_report).to_json
  end

  api! 'List of human reports'
  def index
    human_reports = HumanReport.all
    render(
      json: ActiveModel::ArraySerializer.new(
        human_reports,
        each_serializer: Api::V1::HumanReportSerializer,
        root: 'human_reports',
        #meta: meta_attributes(games)
      )
    )
  end
end
