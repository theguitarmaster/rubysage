Responder.define("are you ([a-zA-Z0-9 ]*)\?") do
  name    "Are you?"
  version "1.0.0"
  details "Find out if you are a something."
  usage   "Are you a xxx?"
  
  def run(tweet, matches)
    "@#{tweet.user.screen_name} No I'm not #{matches.first}!"
  end
end