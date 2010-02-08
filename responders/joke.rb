Responder.define("tell me a joke") do
  name    "Joke"
  version "1.0.0"
  details "Will tell you a random funny joke from recent public tweets"
  usage   "tell me a joke"
  
  def run(tweet, matches)
    joke = Twitter::Search.new('#joke').sort_by{rand}.first
    
    "@#{tweet.user.screen_name} #{joke.text}"
  end
end