require 'chronic'

Plugin.define("when is ([a-zA-Z0-9 ]*)\?") do
  name    "When is?"
  version "1.0.0"
  details "Find out when something is."
  usage   "When is xxx?"
  
  def run(tweet, matches)
    "@#{tweet.from_user} #{matches.first} is #{Chronic.parse(matches.first)}."
  end
end