Action.define("switcharoo") do
  def run
    swaps = {
      'guitar' => 'wang',
      'head' => 'weener',
      'pocket' => 'bottom',
      'dried' => 'tickled',
      'walk' => 'prance'
    }
    word    = swaps.keys.to_a.sort_by{rand}.first
    replace = swaps[word]
    tweet = Twitter::Search.new(word).sort_by{rand}.first
    tweet.text.sub word, replace
  end
end