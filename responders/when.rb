require 'chronic'

Responder.define("when is ([a-zA-Z0-9 ]*)\?") do
  def run(tweet, matches)
    "@#{tweet.user.screen_name} #{matches.first} is #{Chronic.parse(matches.first)}."
  end
end