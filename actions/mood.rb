Action.define("mood") do
  def run
    moods = [
      'angry',
      'sleepy',
      'horny',
      'sad',
      'happy',
      'excited',
      'very ill',
      'ecstatic',
      'lonely',
      'blue',
      'drunk',
      'naked',
      'sober'
    ]
    mood = moods.sort_by{rand}.first
    "I'm currently #{mood}"
  end
end