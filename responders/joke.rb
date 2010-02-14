Responder.define("tell me a joke") do
  def run(tweet, matches)
    joke = Twitter::Search.new('#joke').sort_by{rand}.first
    "@#{tweet.user.screen_name} #{joke.text}"
  end
end