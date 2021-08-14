-- various icons for things

------------------------------
-- notes
--
-- note: i'm not in love with all of these. will revisit.
--
------------------------------

local glyphs = {}

function glyphs.a(x,y)
  screen.pixel(x,y-5)
  screen.pixel(x+2,y-5)
  screen.pixel(x+4,y-5)
  screen.pixel(x+1,y-4)
  screen.pixel(x+3,y-4)
  screen.pixel(x,y-3)
  screen.pixel(x+2,y-3)
  screen.pixel(x+4,y-3)
  screen.pixel(x+1,y-2)
  screen.pixel(x+3,y-2)
  screen.pixel(x,y-1)
  screen.pixel(x+2,y-1)
  screen.pixel(x+4,y-1)
  screen.fill()
end

function glyphs.b(x,y)
  screen.pixel(x,y-5)
  screen.pixel(x+2,y-5)
  screen.pixel(x+4,y-5)
  screen.pixel(x,y-3)
  screen.pixel(x+2,y-3)
  screen.pixel(x+4,y-3)
  screen.pixel(x,y-1)
  screen.pixel(x+2,y-1)
  screen.pixel(x+4,y-1)
  screen.fill()
end

function glyphs.c(x,y)
  screen.pixel(x,y-5)
  screen.pixel(x+1,y-5)
  screen.pixel(x+3,y-4)
  screen.pixel(x+4,y-4)
  screen.pixel(x,y-3)
  screen.pixel(x+1,y-3)
  screen.pixel(x+3,y-2)
  screen.pixel(x+4,y-2)
  screen.pixel(x,y-1)
  screen.pixel(x+1,y-1)
  screen.fill()
end

function glyphs.d(x,y)
  screen.pixel(x,y-5)
  screen.pixel(x+4,y-5)
  screen.pixel(x+3,y-4)
  screen.pixel(x,y-3)
  screen.pixel(x+2,y-3)
  screen.pixel(x+4,y-3)
  screen.pixel(x+1,y-2)
  screen.pixel(x,y-1)
  screen.pixel(x+4,y-1)
  screen.fill()
end

function glyphs.e(x,y)
  screen.pixel(x,y-5)
  screen.pixel(x+2,y-5)
  screen.pixel(x+1,y-4)
  screen.pixel(x,y-3)
  screen.pixel(x+4,y-3)
  screen.pixel(x+3,y-2)
  screen.pixel(x+2,y-1)
  screen.pixel(x+4,y-1)
  screen.fill()
end

function glyphs.f(x,y)
  screen.pixel(x+2,y-5)
  screen.pixel(x+1,y-4)
  screen.pixel(x+3,y-4)
  screen.pixel(x,y-3)
  screen.pixel(x+4,y-3)
  screen.pixel(x+1,y-2)
  screen.pixel(x+3,y-2)
  screen.pixel(x+2,y-1)
  screen.fill()
end

function glyphs.g(x,y)
  screen.pixel(x,y-5)
  screen.pixel(x+4,y-5)
  screen.pixel(x+2,y-4)
  screen.pixel(x+1,y-3)
  screen.pixel(x+3,y-3)
  screen.pixel(x+2,y-2)
  screen.pixel(x,y-1)
  screen.pixel(x+4,y-1)
  screen.fill()
end

function glyphs.h(x,y)
  screen.pixel(x,y-5)
  screen.pixel(x+2,y-5)
  screen.pixel(x+4,y-5)
  screen.pixel(x,y-4)
  screen.pixel(x+4,y-4)
  screen.pixel(x+2,y-2)
  screen.pixel(x,y-1)
  screen.pixel(x+2,y-1)
  screen.pixel(x+4,y-1)
  screen.fill()
end

function glyphs.i(x,y)
  screen.pixel(x+2, y-5)
  screen.pixel(x+2, y-4)
  screen.pixel(x+2, y-3)
  screen.pixel(x+2, y-1)
  screen.fill()
end

function glyphs.off(x,y)
  screen.pixel(x+1, y-4)
  screen.pixel(x+2, y-4)
  screen.pixel(x+3, y-4)
  screen.pixel(x+1, y-3)
  screen.pixel(x+3, y-3)
  screen.pixel(x+1, y-2)
  screen.pixel(x+2, y-2)
  screen.pixel(x+3, y-2)
  screen.fill()
end

function glyphs.on(x,y)
  screen.pixel(x+2, y-5)
  screen.pixel(x, y-3)
  screen.pixel(x+2, y-3)
  screen.pixel(x+4, y-3)
  screen.pixel(x+2, y-1)
  screen.fill()
end

return glyphs