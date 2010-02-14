Responder.define("tell me a ([a-zA-Z0-9 ]*) joke") do
  def run(tweet, matches)
    joke = Twitter::Search.new("#joke #{matches.first}").sort_by{rand}.first
    "@#{tweet.user.screen_name} #{joke.text}"
  end
end
