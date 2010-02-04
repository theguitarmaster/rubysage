require 'chronic'

Plugin.define("when is (.*?)\?") do
  name    "When is?"
  version "1.0.0"
  details "Find out when something is."
  usage   "When is xxx?"
  
  def run(client, tweet, arguments)
    client.update "@#{tweet.from_user} #{arguments.first} is #{Chronic.parse(arguments.first)}."
  end
end