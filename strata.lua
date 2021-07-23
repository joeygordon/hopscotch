-- Strata
-- 
-- big-time Stratus ripoff
-- (for now)
--
-- -----------------------
--
-- v0.1.0 by @joeygordon
-- link to lines eventually

-- engine.name = 'PolySub'


music = require 'musicutil'
m = midi.connect()

local sequences = include("lib/sequences")
local screen_y = 40
local screen_x_mult = 10
local positions = {
  "_",
  "_",
  "_",
  "_",
}
local voices = {
  [1] = {
    sequence = sequences[1], 
    note = nil,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
  [2] = {
    sequence = sequences[2], 
    note = nil,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
  [3] = {
    sequence = sequences[3], 
    note = nil,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
  [4] = {
    sequence = sequences[4], 
    note = nil,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
}

function play_sequence(seq, voice)
  while true do
    for i=1, #seq do
      clock.sync(1/4)
      if seq[i] == 1 then
        positions[voice] = "*"
      else
        positions[voice] = "_"
      end
      redraw()
    end
  end
end

function find_empty_space()
  -- cycle through voices and return first available voice
  for k, v in ipairs(voices) do
    if voices[k]["note"] == nil then
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
  if n==3 or n==2 or n==1 then
    if z==1 then
      voice_space = find_empty_space()

      if voice_space ~= false then
        print('space', n, voice_space)
        voices[voice_space]["note"] = n
        voices[voice_space]["clock"] = clock.run(play_sequence, voices[voice_space]["sequence"] , voice_space)
      end
    else
      for k, v in pairs(voices) do
        if v["note"] == n then
          clock.cancel(voices[k]["clock"])
          voices[k]["note"] = nil
          positions[k] = "_"
          redraw()
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