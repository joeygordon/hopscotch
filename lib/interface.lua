local interface = {}
local screen_y = 35
local screen_x_mult = 14

function interface.draw_gate(mode)
  -- gate length
  screen.level(1)
  screen.move(2, 5)
  if mode == 0 then
    screen.line_width(3)
  else
    screen.line_width(1)
  end
  screen.line(15, 5)
  screen.close()
  screen.stroke()
end

function interface.draw_hold()
  screen.level(1)
  screen.line_width(1)
  screen.rect(107, 2, 20, 6)
  screen.stroke()
end

function interface.draw_settings(selected, voices)
  for i=1, #voices do
    if selected == i then
      screen.level(15)
    else
      screen.level(2)
    end
    screen.move((screen_x_mult * i) - 3, screen_y + 10)
    screen.text(voices[i].sequence)
  end
end

function interface.draw_activity(voices, voice_status)
  screen.level(15)
  for i=1, #voices do
    screen.move((screen_x_mult * i) - 3, screen_y)
    screen.text(voice_status[i])
  end
end

return interface