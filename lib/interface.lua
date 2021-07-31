-- draw stuff on the screen
glyphs = include 'lib/glyphs'

local interface = {}
local screen_y = 35
local screen_x_mult = 14

function interface.draw_clock_div()
  screen.level(1)
  screen.move(1, 9)
  screen.text(clock_div_options[params:get('strata_clock_division')])
end

function interface.draw_gate()
  -- gate length
  screen.level(1)
  if params:get('strata_output') == 2 then
    screen.move(88, 9)
    screen.text('int')
  else
    screen.move(88, 7)
    screen.line_width(3)
    screen.line_rel(15 * gate_values[params:get('strata_gate_length')], 0)
    screen.close()
    screen.stroke()
  end
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

function interface.draw_sequences()
  for i=1, #voices do
    if selected == i then
      screen.level(15)
    else
      screen.level(2)
    end
    local sequence_index = params:get("strata_v"..i.."_sequence")
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
    screen.move((screen_x_mult * i) - 3, screen_y + 12)
    screen.text(params:get("strata_v"..i.."_channel"))
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

function interface.draw_settings()
  screen.move(screen_x_mult * 1,screen_y)
    if shift == true then
      screen.text("shifting")
    else
      screen.text("settings screen")
    end
    glyphs.a(10,15)
    glyphs.b(18,15)
    glyphs.c(26,15)
    glyphs.d(34,15)
    glyphs.e(42,15)
    glyphs.f(50,15)
    glyphs.g(58,15)
    glyphs.h(66,15)
end

return interface