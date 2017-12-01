class Api::V1::PeopleController < ApplicationController
  before_filter :check_admin, :except => [ :show, :index ]
  #respond_to :json
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  api! 'A specific person'
  def show
    person = Person.find(params[:id])
    render json: Api::V1::PersonSerializer.new(person).to_json
  end

  # need to authenticate this one
  # def update
  #   person = Person.find(params[:id])
  # end

  api! 'List of people'
  def index
    people = Person.all
    render(
      json: ActiveModel::ArraySerializer.new(
        people,
        each_serializer: Api::V1::PersonSerializer,
        root: 'people',
        #meta: meta_attributes(people)
      )
    )
  end
end
