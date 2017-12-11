class Api::V1::RegistrationsController < Api::V1::BaseController
  before_filter :check_admin, :except => [ :show, :index, :by_faction ]
  #respond_to :json
  resource_description do
    name 'Player Registrations'
    short 'Registation info for players'
    formats ['json']
    error 404, "Could not find resource. Will respond with {error: 'not found', success: false}"
    error 400, "Invalid parameters. Will responsd with {error: 'invalid params', success: false}"
  end


  api! 'A specific registration'
  meta 'registration' => {
    "person_id" => "the id of the player",
    "game_id" => "id of the game this player is registered to play",
    "faction_id" => "name or id of the faction. Valid options are: "+
      Registration::FACTION_NAMES[Registration::HUMAN_FACTION]+'('+Registration::HUMAN_FACTION.to_s+'), '+
      Registration::FACTION_NAMES[Registration::ZOMBIE_FACTION]+'('+Registration::ZOMBIE_FACTION.to_s+'), '+
      'or '+Registration::FACTION_NAMES[Registration::DECEASED_FACTION]+'('+Registration::DECEASED_FACTION.to_s+')',
    "card_code" => "unique player code",
    "mission_ids" => "missions that the player is registered for"
  }
  example <<-EOS
  {
    "registration":
    {
      "person_id": 1,
      "game_id": 1,
      "faction_id": 0,
      "card_code": "D391F7",
      "mission_ids": []
    }
  }
  EOS
  def show
    registration = Registration.find(params[:id])
    render_registration registration
  end


  api! 'List of all registrations'
  example <<-EOS
  {
    "registrations": [
      {"person_id":1,"game_id":1,"faction_id":0,"card_code":"D391F7","mission_ids":[]},
      {"person_id":2,"game_id":1,"faction_id":0,"card_code":"8B183C","mission_ids":[]},
      {"person_id":26,"game_id":1,"faction_id":0,"card_code":"7A9843","mission_ids":[]},
      {"person_id":27,"game_id":1,"faction_id":0,"card_code":"146F83","mission_ids":[]},
      {"person_id":28,"game_id":1,"faction_id":0,"card_code":"B93339","mission_ids":[]}
    ]
  }
  EOS
  see "registrations#show", "Format of a single registration"
  def index
    registrations = Registration.all
    render_registrations registrations
  end


  api! 'Get registrations that are part of a certain faction (optionally by card code as well).
  If you specify a card code, it will return the first matching registration. If you don\'t, it will
  return all registations in that faction.'
  meta 'registration' => {
    "person_id" => "the id of the player",
    "game_id" => "id of the game this player is registered to play",
    "faction_id" => "name or id of the faction. Valid options are: "+
      Registration::FACTION_NAMES[Registration::HUMAN_FACTION]+'('+Registration::HUMAN_FACTION.to_s+'), '+
      Registration::FACTION_NAMES[Registration::ZOMBIE_FACTION]+'('+Registration::ZOMBIE_FACTION.to_s+'), '+
      'or '+Registration::FACTION_NAMES[Registration::DECEASED_FACTION]+'('+Registration::DECEASED_FACTION.to_s+')',
    "card_code" => "unique player code",
    "mission_ids" => "missions that the player is registered for"
  }
  param :faction, String, "faction id or short name", :required => true
  param :card_code, String, "player card code", :required => false
  example <<-EOS
  {
    "registrations": [
      {"person_id":1,"game_id":1,"faction_id":0,"card_code":"D391F7","mission_ids":[]},
      {"person_id":2,"game_id":1,"faction_id":0,"card_code":"8B183C","mission_ids":[]},
      {"person_id":26,"game_id":1,"faction_id":0,"card_code":"7A9843","mission_ids":[]},
      {"person_id":27,"game_id":1,"faction_id":0,"card_code":"146F83","mission_ids":[]},
      {"person_id":28,"game_id":1,"faction_id":0,"card_code":"B93339","mission_ids":[]}
    ]
  }
  EOS
  see "registrations#show", "Format of a single registration"
  def by_faction
    def render_faction_error
      render json: {
        error: { "Unknown faction name or id": params[:faction] },
        known_factions: {
          human: {id: Registration::HUMAN_FACTION, name: Registration::FACTION_NAMES[Registration::HUMAN_FACTION]},
          zombie: {id: Registration::ZOMBIE_FACTION, name: Registration::FACTION_NAMES[Registration::ZOMBIE_FACTION]},
          deceased: {id: Registration::DECEASED_FACTION, name: Registration::FACTION_NAMES[Registration::DECEASED_FACTION]}
        },
        success: false
      }, status: 404
    end
    if !params.has_key?(:faction)
      render_faction_error
    end

    faction = params[:faction]
    card_code = params.has_key?(:card_code) ? params[:card_code] : nil

    def registation_logic (faction_id)
      card_code = params.has_key?(:card_code) ? params[:card_code] : nil
      if (card_code.nil?)
        registrations = Registration.where(faction_id: faction_id)
        render_registrations registrations
      else
        registration = Registration.find_by!(faction_id: faction_id, card_code: card_code)
        render_registration registration
      end
    end

    if (faction == Registration::HUMAN_FACTION.to_s or faction.downcase == Registration::FACTION_NAMES[Registration::HUMAN_FACTION])
      registation_logic Registration::HUMAN_FACTION
    elsif (faction == Registration::ZOMBIE_FACTION.to_s or faction.downcase == Registration::FACTION_NAMES[Registration::ZOMBIE_FACTION])
      registation_logic Registration::ZOMBIE_FACTION
    elsif (faction == Registration::DECEASED_FACTION.to_s or faction.downcase == Registration::FACTION_NAMES[Registration::DECEASED_FACTION])
      registation_logic Registration::DECEASED_FACTION
    else
      render_faction_error
    end
  end


  private
  def render_registrations (registrations)
    render(
      json: ActiveModel::ArraySerializer.new(
        registrations,
        each_serializer: Api::V1::RegistrationSerializer,
        root: 'registrations',
        #meta: meta_attributes(games)
      )
    )
  end

  def render_registration (registration)
    render json: Api::V1::RegistrationSerializer.new(registration).to_json
  end
end
