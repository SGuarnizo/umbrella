# Write your soltuion here!
require "dotenv/load"
require "http"

key = ENV.fetch ("GMAPS_KEY")
pp "Hi! Where are you located?"

#user_loc = gets.chomp

user_loc = "Conjunto Residencial Penas Blancas"

pp user_loc

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_loc}&key=#{key}"

pp gmaps_url

pp HTTP.get(gmaps_url).to_s
