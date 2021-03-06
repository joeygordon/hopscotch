-- draw stuff on the screen

glyphs = include 'lib/glyphs'

local interface = {}
local screen_y = 29
local screen_x_mult = 14

function interface.draw_clock_div()
  if selected == #voices + 1 then
    screen.level(10)
  else
    screen.level(2)
  end
  screen.move(1, 64)
  screen.text(clock_div_options[params:get('hs_clock_division')])
end

function interface.draw_gate()
  -- gate length

  if params:get('hs_output') == 2 then
    if selected == #voices + 2 then
      screen.level(10)
    else
      screen.level(1)
    end
    
    screen.move(114, 64)
    screen.text('int')
  else
    screen.level(1)
    screen.move(109, 62)
    screen.line_width(3)
    screen.line_rel(19, 0)
    screen.close()
    screen.stroke()

    if selected == #voices + 2 then
      screen.level(10)
    else
      screen.level(3)
    end

    screen.move(109, 62)
    screen.line_rel(19 * gate_values[params:get('hs_gate_length')], 0)
    screen.close()
    screen.stroke()
  end
end

function interface.draw_hold()
  screen.line_width(1)
  if params:get('hs_hold') == 1 then
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

function interface.draw_sequences()
  for i=1, #voices do
    if selected == i then
      screen.level(15)
    else
      screen.level(2)
    end
    local sequence_index = params:get("hs_v"..i.."_sequence")
    sequences[sequence_index].glyph((screen_x_mult * i) - 3, screen_y + 12)
  end
end

function interface.draw_channels()
  for i=1, #voices do
    if selected == i then
      screen.level(15)
    else
      screen.level(2)
    end
    screen.move((screen_x_mult * i) - 2, screen_y + 12)
    screen.text(params:get("hs_v"..i.."_channel"))
  end
end

function interface.draw_activity()
  screen.level(15)
  for i=1, #voices do
    if voice_status[i] == 0 then
      glyphs.off((screen_x_mult * i) - 3, screen_y)
    elseif voice_status[i] == 1 then
      glyphs.on((screen_x_mult * i) - 3, screen_y)
    end
  end
end

return interface