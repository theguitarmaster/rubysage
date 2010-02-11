Responder.define("tell me a ([a-zA-Z0-9 ]*) joke") do
  name    "Joke_type"
  version "1.0.0"
  details "Will tell you a random funny joke from recent public tweets. Currently only works with one word, i.e. fat, not fat mama."
  usage   "tell me a xxx joke"
  
  def run(tweet, matches)
    joke_type = Twitter::Search.new("#joke #{matches.first}").sort_by{rand}.first
    
    "@#{tweet.user.screen_name} #{joke_type.text}"
  end
end
