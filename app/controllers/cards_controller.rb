
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
    if response == nil
      puts "error with http request"
    end 

    parsed_body = JSON.parse(response.body)
    if parsed_body == nil 
      puts "error parsing data"
    end 
    @access_token = parsed_body["access_token"]
  end

 
 def index 
  @access_token = get_token

  @cards = HTTP.auth("Bearer #{@access_token}").get("https://us.api.blizzard.com/hearthstone/cards?locale=en_US&class=druid%2Cwarlock&manaCost=7%2C8%2C9%2C10&rarity=legendary")
  if @cards == nil
    puts "error with http request"
  end
  @cards = JSON.parse(@cards.body)
  if @cards == nil
    puts "error parsing data"
  end

  @sets = HTTP.auth("Bearer #{@access_token}").get("https://us.api.blizzard.com/hearthstone/metadata/sets?locale=en_US")
  if @sets == nil
    puts "error with http request"
  end
  @sets = JSON.parse(@sets.body)
  if @sets == nil
    puts "error parsing data"
  end

  
  @cards_array = []

  @cards["cards"].each do |c|
    setId = c["cardSetId"]
    @sets.each do |s|
      setName = s["id"]
      if setId == setName
        c["cardSetId"] = s["name"]
      end
    end
    if c["classId"] == 2
      c["classId"] = "Druid"
    elsif c["classId"] == 9
      c["classId"] = "Warlock"
    else 
      puts "#{c["name"]} is not a warlock or druid"
    end
    if c["rarityId"] == 5
      c["rarityId"] = "Legendary"
    else 
      puts "#{c["name"]} is not legendary"
    end
    if c["cardTypeId"] == 3
      c["cardTypeId"] = "Hero"
    elsif c["cardTypeId"] == 4
      c["cardTypeId"] = "Minion"
    elsif c["cardTypeId"] == 5
      c["cardTypeId"] = "Spell"
    elsif
      c["cardTypeId"] == 7
      c["cardTypeId"] = "Weapon"
    elsif
       c["cardTypeId"] == 10
      c["cardTypeId"] = "HeroPower"
    else 
      puts "error finding card type of #{c["name"]} "
    end 
    if (c["cardSetId"].is_a? String) && (c["cardTypeId"].is_a? String) && (c["rarityId"].is_a? String) && (c["classId"].is_a? String)
      @cards_array << c 
    else 
      puts "error converting ids of #{c["name"]} to human readible data"
    end
  end
  @hand = @cards_array.sample(10)
  if @hand.length < 10 
    puts "oops you need more cards!"
  elsif @hand.length > 10 
    puts "oh no you have too many cards!"
  end
  @hand.sort! {|a, b| a["id"] <=> b["id"]}
 end 
end

