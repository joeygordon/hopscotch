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


local voices = include("lib/voices")
local screen_y = 40
local screen_x_mult = 10
local voice_status = {
  "_",
  "_",
  "_",
  "_",
  "_",
  "_",
  "_",
  "_",
}

function play_sequence(seq, voice)
  while true do
    for i=1, #seq do
      clock.sync(1/4)
      if seq[i] == 1 then
        voice_status[voice] = "*"
        engine.amp(voices[voice]["velocity"] / 127)
        engine.hz(music.note_num_to_freq(voices[voice]["note"]))
      else
        voice_status[voice] = "_"
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
        voice_status[k] = "_"
        redraw()
      end
    end
  end
end

function key(n,z)
  -- key actions: n = number, z = state
  if n==3 then
    if z==1 then
      -- on key down
    else
      -- on key up
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
  screen.text(voice_status[1])
  screen.move(screen_x_mult * 2, screen_y)
  screen.text(voice_status[2])
  screen.move(screen_x_mult * 3,screen_y)
  screen.text(voice_status[3])
  screen.move(screen_x_mult * 4, screen_y)
  screen.text(voice_status[4])
  screen.move(screen_x_mult * 5, screen_y)
  screen.text(voice_status[5])
  screen.move(screen_x_mult * 6, screen_y)
  screen.text(voice_status[6])
  screen.move(screen_x_mult * 7, screen_y)
  screen.text(voice_status[7])
  screen.move(screen_x_mult * 8, screen_y)
  screen.text(voice_status[8])
  screen.update()
end

function cleanup()
  -- deinitialization
end