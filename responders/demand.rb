Responder.define("(tell|give|show) me (a |an )([a-zA-Z0-9]* )?([a-zA-Z0-9 ]*)") do
  def run(tweet, matches)

    matches.flatten! # not sure why having to do this - appears to be nested array
    
    search_terms = []
    search_terms << "##{matches[3]}" #topic
    search_terms << matches[2] unless matches[2].nil? || matches[2].empty? #type
    
    # Find tweets that look like possibly on topic
    potentials = Twitter::Search.new(search_terms.join(' ').to_s)
    candidates = []
    if potentials.nil?
      "I've got no inspiration at the moment. Try again later."
    else
      # Strip out ones that mention someone so as not to annoy anyone
      potentials.each { |p| candidates << p unless p.include?('@') }
      # pick one at random to actually use
      if candidates.empty?
        "Sorry, I can't think of anything right now."
      else
        winner = candidates.sort_by{rand}.first
        # Reply with the message - hoping that it's relevant and funny!
        "@#{tweet.user.screen_name} #{winner.text}"
      end
    end
  end
end
