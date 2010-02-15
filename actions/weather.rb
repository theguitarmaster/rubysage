require 'yahoo-weather'

Action.define("weather") do
  def run
    weather_client = YahooWeather::Client.new
    weather = weather_client.lookup_by_woeid(44418) # london
    "Looks like #{weather.forecasts[1].text.downcase} tomorrow."
  end
end