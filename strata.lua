-- Strata
-- 
-- big-time Stratus ripoff
-- (for now)
--
-- -----------------------
--
-- v0.1.0 by @joeygordon
-- link to lines eventually

engine.name = 'PolyPerc'

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
  "_",
  "_",
  "_",
  "_",
}
local voices = {
  {
    sequence = sequences[1], 
    note = nil,
    velocity = 60,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
  {
    sequence = sequences[2], 
    note = nil,
    velocity = 60,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
  {
    sequence = sequences[3], 
    note = nil,
    velocity = 60,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
  {
    sequence = sequences[4], 
    note = nil,
    velocity = 60,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
  {
    sequence = sequences[5], 
    note = nil,
    velocity = 60,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
  {
    sequence = sequences[6], 
    note = nil,
    velocity = 60,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
  {
    sequence = sequences[7], 
    note = nil,
    velocity = 60,
    channel = 1,
    available = true,
    length = 10,
    clock={}
  },
  {
    sequence = sequences[8], 
    note = nil,
    velocity = 60,
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
        engine.amp(voices[voice]["velocity"] / 127)
        engine.hz(music.note_num_to_freq(voices[voice]["note"]))
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
    if voices[k]["available"] == true then
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
  print(d)
  if d.type == "note_on" then
    voice_space = find_empty_space()
    voices[voice_space]["note"] = d.note
    voices[voice_space]["available"] = false
    voices[voice_space]["velocity"] = d.vel
    voices[voice_space]["clock"] = clock.run(play_sequence, voices[voice_space]["sequence"] , voice_space)
  elseif d.type == "note_off" then
    -- note off things
    for k, v in pairs(voices) do
      if v["note"] == d.note then
        clock.cancel(voices[k]["clock"])
        voices[k]["available"] = true
        voices[k]["note"] = nil
        voices[k]["velocity"] = 0
        positions[k] = "_"
        redraw()
      end
    end
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
  screen.move(screen_x_mult * 5, screen_y)
  screen.text(positions[5])
  screen.move(screen_x_mult * 6, screen_y)
  screen.text(positions[6])
  screen.move(screen_x_mult * 7, screen_y)
  screen.text(positions[7])
  screen.move(screen_x_mult * 8, screen_y)
  screen.text(positions[8])
  screen.update()
end

function cleanup()
  -- deinitialization
end