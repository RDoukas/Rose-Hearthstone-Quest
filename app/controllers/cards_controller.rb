
require 'net/http'
require 'uri'


class CardsController < ApplicationController

 def get_token
  uri = URI.parse("https://us.battle.net/oauth/token")
  request = Net::HTTP::Post.new(uri)
  request.basic_auth(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"])
  request.set_form_data(
  "grant_type" => "client_credentials",
 )

 req_options = {
   use_ssl: uri.scheme == "https",
 }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
   http.request(request)
  end
  # ERROR unable to get response.

  parsed_body = JSON.parse(response.body)
  # ERROR unable to parse data
  parsed_body["access_token"]
  # ERROR, no token found.
  end

 
 def index 
  access_token = get_token
  @cards = HTTP.auth("Bearer #{access_token}").get("https://us.api.blizzard.com/hearthstone/cards?locale=en_US&class=druid%2Cwarlock&manaCost=7%2C8%2C9%2C10&rarity=legendary")
  # ERROR unable to process request
  @cards = JSON.parse(@cards.body)
  # ERROR unable to parse

  # needs to get moved down after all the checking :(
  @hand = @cards["cards"].sample(10)
  # ERROR deck is less than 10 cards
  @hand.sort! {|a, b| a["id"] <=> b["id"]}
  

  @hand.each do |h|
    if h["rarityId"] == 5
      h["rarityId"] = "Legendary"
    else 
      render json: "this card is not legendary"
      # ERROR
    end
    if h["classId"] == 2
      h["classId"] = "Druid"
    elsif h["classId"] == 9
      h["classId"] = "Warlock"
    else 
      # ERROR 
      render json: "this card is not a warlock or druid"
    end
    if h["cardTypeId"] == 3
      h["cardTypeId"] = "Hero"
    elsif h["cardTypeId"] == 4
      h["cardTypeId"] = "Minion"
    elsif h["cardTypeId"] == 5
      h["cardTypeId"] = "Spell"
    elsif
      h["cardTypeId"] == 7
      h["cardTypeId"] = "Weapon"
    elsif
       h["cardTypeId"] == 10
      h["cardTypeId"] = "HeroPower"
    else 
      # ERROR invalid type
    end 
    # MAKE SURE ALL WORK 
  end
  # ERROR, if any fields are numbers (yess, displayed as nums in return)

  @sets = HTTP.auth("Bearer #{access_token}").get("https://us.api.blizzard.com/hearthstone/metadata/sets?locale=en_US")
  # ERROR
  @sets = JSON.parse(@sets.body)
  # ERROR

  @hand.each do |h|
    setId = h["cardSetId"]
    @sets.each do |s|
      setName = s["id"]
      if setId == setName
        h["cardSetId"] = s["name"]
      end
    end
  end
 end 
end

