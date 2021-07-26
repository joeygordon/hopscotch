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
-- why doesn't this work?
-- engine.cutoff(1000)

music = require 'musicutil'
utils = include 'lib/utils'
interface = include 'lib/interface'
m = midi.connect(1)
o = midi.connect(2)

local voices = include("lib/voices")
local screen_y = 35
local screen_x_mult = 14
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
local clock_division = 1/4
local grid_lock = true
local page = 0
local output_mode = 1

function play_note(note, vel)
  if output_mode == 0 then
    engine.hz(music.note_num_to_freq(note))
    engine.amp(vel / 127)
  elseif output_mode == 1 then
    o:note_on(note, vel, 2)
    clock.run(kill_note, note, vel)
  end
end

function kill_note(note, vel)
  clock.sleep(0.5)
  o:note_off(note, vel, 2)
end

function play_sequence(seq, voice)
  while true do
    for i=1, #seq do
      if seq[i] == 1 then
        voice_status[voice] = "*"
        note_val = utils.percentageChance(20) and 
          (voices[voice]["note"] + utils.randomOctave()) or 
          voices[voice]["note"]
        play_note(note_val, voices[voice]["velocity"], clock)
      else
        voice_status[voice] = "_"
      end
      redraw()
      if grid_lock == true then
        clock.sync(clock_division)
      else 
        clock.sleep(clock.get_beat_sec() / 4)
      end
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

function toggle_output()
  if output_mode == 0 then
    output_mode = 1
  else
    output_mode = 0
  end
  redraw()
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
      toggle_output()
    else
      -- on key up
    end
  end
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    -- swtich mode to settings screen and back
    page = util.clamp(d, 0, 1)
    redraw()
  end
end

function draw_activity()
  screen.level(15)
  screen.move(screen_x_mult - 3,screen_y)
  screen.text(voice_status[1])
  screen.move((screen_x_mult * 2) - 3, screen_y)
  screen.text(voice_status[2])
  screen.move((screen_x_mult * 3) - 3,screen_y)
  screen.text(voice_status[3])
  screen.move((screen_x_mult * 4) - 3, screen_y)
  screen.text(voice_status[4])
  screen.move((screen_x_mult * 5) - 3, screen_y)
  screen.text(voice_status[5])
  screen.move((screen_x_mult * 6) - 3, screen_y)
  screen.text(voice_status[6])
  screen.move((screen_x_mult * 7) - 3, screen_y)
  screen.text(voice_status[7])
  screen.move((screen_x_mult * 8) - 3, screen_y)
  screen.text(voice_status[8])
end

function redraw()
  screen.clear()

  -- main screen
  if page == 0 then 
    interface.draw_gate()
    interface.draw_hold()
    draw_activity()
  -- settings screen
  elseif page == 1 then
    screen.move(screen_x_mult * 1,screen_y)
    screen.text("settings screen")
  end

  screen.update()
end

function cleanup()
  -- deinitialization
end