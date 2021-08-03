-- all of the possible sequences

local sequences = {
  {
    glyph = glyphs.a,
    steps = {1, 0, 0, 0, 0, 0, 0, 0}
  },
  {
    glyph = glyphs.b,
    steps = {1, 0, 0, 0}
  },
  {
    glyph = glyphs.c,
    steps = {1, 0, 0, 1}
  },
  {
    glyph = glyphs.d,
    steps = {1, 0, 0}
  },
  {
    glyph = glyphs.e,
    steps = {0, 1, 1, 0, 0}
  },
  {
    glyph = glyphs.f,
    steps = {1, 0, 0, 1, 1, 0, 1, 0, 0}
  },
  {
    glyph = glyphs.g,
    steps = {0, 0, 1, 0, 1}
  },
  {
    glyph = glyphs.h,
    steps = {0, 0, 0, 1, 0}
  },
  -- random sequence option. MUST BE LAST
  {
    glyph = glyphs.i,
    steps = nil
  },
}

return sequences