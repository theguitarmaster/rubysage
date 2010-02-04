Plugin.define("are you (.*?)\?") do
  name    "Are you?"
  version "1.0.0"
  details "Find out if you are a something."
  usage   "Are you a xxx?"
  
  def run(client, tweet, arguments)
    client.update "@#{tweet.from_user} No I'm not #{arguments.first}!"
  end
end