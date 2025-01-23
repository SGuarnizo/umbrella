# Write your soltuion here!
require "dotenv/load"
require "json"
require "http"

key = ENV.fetch ("GMAPS_KEY")
pp "Hi! Where are you located?"

user_loc = gets.chomp

pp user_loc

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_loc}&key=#{key}"

google= HTTP.get(gmaps_url)
parsed_google = JSON.parse(google)

results = parsed_google.fetch("results","error")
array = results.at(0)
geometry = array.fetch("geometry","error")
location = geometry.fetch("location","error")
lat= location.fetch("lat","error")
lng= location.fetch("lng","error")

pirate_key = ENV.fetch("PIRATE_KEY")
pirate_url = "https://api.pirateweather.net/forecast/#{pirate_key}/#{lat},#{lng}"

pirate= HTTP.get(pirate_url)
parsed_pirate = JSON.parse(pirate)

currently = parsed_pirate.fetch("currently","error")
temp = currently.fetch("temperature","error")

tempc = (temp.to_f-32)*5/9

pp tempc
