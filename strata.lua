-- Strata
-- 
-- big-time Stratus ripoff
-- (for now)
--
-- -----------------------
--
-- v0.1.0 by @joeygordon
-- link to lines eventually

engine.name = 'PolySub'

local sequences = include("lib/sequences")
local screen_y = 40
local screen_x_mult = 10
local positions = {
  1,
  1,
  1,
  1,
}

music = require 'musicutil'
m = midi.connect()

local voices = {
  {
    Sequence = sequences[1], 
    Note = nil,
    Channel = 1,
    Available = true,
    Length = 10,
    Clock={}
  },
  {
    Sequence = sequences[2], 
    Note = nil,
    Channel = 1,
    Available = true,
    Length = 10,
    Clock={}
  },
  {
    Sequence = sequences[3], 
    Note = nil,
    Channel = 1,
    Available = true,
    Length = 10,
    Clock={}
  },
  {
    Sequence = sequences[4], 
    Note = nil,
    Channel = 1,
    Available = true,
    Length = 10,
    Clock={}
  },
}

local key_voice_index = {}
local next = next

function play_sequence(seq, voice)
  i = 1
  while true do
    clock.sync(1/4)
    if i == #seq then
      i = 1
    else
      i = i + 1
    end
    positions[voice] = i
    redraw()
  end
end

function find_empty_space()
  -- cycle through voices and return first available voice
  for k, v in pairs(voices) do
    if next(voices[k]) == nil then
      print('voice found')
      return k
    end
  end
  return false
end


function init()
  -- initialization stuff
end

-- midi things
m.event = function(data)
  local d = midi.to_msg(data)
  if d.type == "note_on" then
    -- engine.amp(d.vel / 127)
    -- engine.hz(music.note_num_to_freq(d.note))
  elseif d.type == "note_off" then
    -- note off things
  end
end

function key(n,z)
  -- key actions: n = number, z = state
  if n==3 or n==2 then
    if z==1 then
      voice_space = find_empty_space()

      if voice_space ~= false then
        voices[voice_space][Note] = n
        voices[voice_space][Clock] = clock.run(play_sequence, sequences[1], voice_space)
      end
    else
      for k, v in pairs(voices) do
        if v[Note] == n do
          clock.cancel(voices[k][Clock])
          voices[k][Note] = nil
        end
      end
    end
  end
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
end

function redraw()
  -- screen redraw
  screen.clear()
  screen.move(screen_x_mult * 1,screen_y)
  screen.text(positions[1])
  screen.move(screen_x_mult * 2, screen_y)
  screen.text(positions[2])
  screen.move(screen_x_mult * 3,screen_y)
  screen.text(positions[3])
  screen.move(screen_x_mult * 4, screen_y)
  screen.text(positions[4])
  screen.update()
end

function cleanup()
  -- deinitialization
end