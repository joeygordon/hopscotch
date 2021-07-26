local interface = {}

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

return interface