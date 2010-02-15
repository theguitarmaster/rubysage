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
    potentials = Twitter::Search.new(word)
    candidates = []
    response = false
    unless potentials.nil?
      potentials.each { |p| candidates << p unless p.include?('@') }
      unless candidates.empty?
        winner = candidates.sort_by{rand}.first
        response = winner.text.sub(Regexp.new(word, Regexp::IGNORECASE), replace)
      end
    end
    response
  end
end