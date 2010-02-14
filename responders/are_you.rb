Responder.define("are you ([a-zA-Z0-9 ]*)\?") do
  def run(tweet, matches)
    "@#{tweet.user.screen_name} No I'm not #{matches.first}!"
  end
end