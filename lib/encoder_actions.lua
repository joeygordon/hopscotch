local encoder_actions = {}

function encoder_actions.init(n,d)
  -- encoder actions: n = number, d = delta
  -- swtich mode to settings screen and back
  if n == 1 then
    page = util.clamp(d, 0, 1)
    redraw()
  end

  -- select active selected
  if n == 2 then
    selected = util.clamp(selected + d, 1, #voices)
    redraw()
  end

  -- select active selected
  if n == 3 then
    voices[selected].sequence = util.clamp(voices[selected].sequence + d, 1, #sequences)
    redraw()
  end
end

return encoder_actions