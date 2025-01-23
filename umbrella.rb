# Write your soltuion here!
require "dotenv/load"
require "json"
require "http"
require "ascii_charts"

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

pp "Checking the weather at #{user_loc}...."
pp "Your coordinates are #{lat.round(5)}, #{lng.round(5)}."
pp "It is currently #{tempc.round(2)}°C."

hourly = parsed_pirate.fetch("hourly","error")
data = hourly.fetch("data","error")
hora = 0
totalprecip=0
coordinates = []
rain_boolean=false

while hora <= 12
  data_array=data.at(hora) 
  precip = data_array.fetch("precipProbability","error")*100.round(0).to_i
  coordinate = [hora, precip]
  coordinates = coordinates.push(coordinate)
  hora = hora + 1
  totalprecip=totalprecip+precip
    if precip > 0.1
      rain_boolean=true
      preciptime = data_array.fetch("time","error")
      seconds_from_now = preciptime - Time.now.to_i
      hours_from_now = seconds_from_now / 60 / 60
      pp "In #{hours_from_now.round} hours, there is a #{(precip).round}% chance of precipitation."
       
    end
end

if totalprecip > 0
   puts AsciiCharts::Cartesian.new(coordinates,:bar => true, :hide_zero => true).draw
end

if rain_boolean == true
  pp "You might want to take an umbrella!"
else
  pp "You probably won't need an umbrella."
end
