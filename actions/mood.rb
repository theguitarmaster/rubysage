Action.define("mood") do
  def run
    moods = [
      'angry',
      'sleepy',
      'sad',
      'happy',
      'excited',
      'ill',
      'ecstatic',
      'lonely',
      'blue',
      'drunk',
      'sober',
      'squiffy'
    ]
    
    qualifiers = [
      'very',
      'a little',
      'a bit',
      'somewhat',
      'totally',
      'rather',
      'abnormally',
      'strangely',
      'completely',
    ]
    
    mood      = moods.sort_by{rand}.first
    qualifier = qualifiers.sort_by{rand}.first
    "I'm feeling #{qualifier} #{mood}"
  end
end