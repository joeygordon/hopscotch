-- draw stuff on the screen

local interface = {}
local screen_y = 35
local screen_x_mult = 14

function interface.draw_gate()
  -- gate length
  screen.level(1)
  screen.move(2, 5)
  if params:get('strata_output') == 2 then
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
  if params:get('strata_hold') == 1 then
    screen.level(1)
    screen.rect(108, 3, 20, 7)
    screen.fill()
    screen.level(15)
    screen.rect(107, 2, 20, 7)
    screen.fill()
    screen.move(108, 8)
    screen.level(0)
    screen.text('HOLD')
  else
    screen.level(1)
    screen.rect(108, 3, 20, 7)
    screen.fill()
    screen.move(109, 9)
    screen.level(0)
    screen.text('HOLD')
  end
  screen.stroke()
end

function interface.draw_sequences(selected, voices)
  for i=1, #voices do
    if selected == i then
      screen.level(15)
    else
      screen.level(2)
    end
    screen.move((screen_x_mult * i) - 3, screen_y + 10)
    screen.text(params:get("strata_v"..i.."_sequence"))
  end
end

function interface.draw_channels()
  for i=1, #voices do
    if selected == i then
      screen.level(15)
    else
      screen.level(2)
    end
    screen.move((screen_x_mult * i) - 3, screen_y + 10)
    screen.text(params:get("strata_v"..i.."_channel"))
  end
end

function interface.draw_activity(voices, voice_status)
  screen.level(15)
  for i=1, #voices do
    screen.move((screen_x_mult * i) - 3, screen_y)
    screen.text(voice_status[i])
  end
end

function interface.draw_settings(shift)
  screen.move(screen_x_mult * 1,screen_y)
    if shift == true then
      screen.text("shifting")
    else
      screen.text("settings screen")
    end
end

return interface