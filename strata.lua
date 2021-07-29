-- Strata
--
-- -----------------------
--
-- v0.1.0 by @joeygordon
-- link to lines eventually

engine.name = 'PolyPerc'
-- why doesn't this work?
-- engine.cutoff(1000)
m1 = midi.connect(1)
m2 = midi.connect(2)
music = require 'musicutil'
utils = include 'lib/utils'
interface = include 'lib/interface'
voices = include 'lib/voices'
sequences = include 'lib/sequences'
voice_status = { "_", "_", "_", "_", "_", "_", "_", "_" }


local page = 0
local hold = false
local shift = false
local selected = 1
local clock_division = 4
local grid_lock = true
local output_mode = 1
local gate_length = 0.5

function kill_note(note, vel)
  clock.sleep(clock.get_beat_sec() / (clock_division * 2))
  m2:note_off(note, vel, 2)
end

function play_note(note, vel)
  if output_mode == 0 then
    engine.amp(vel / 127)
    engine.hz(music.note_num_to_freq(note))
  elseif output_mode == 1 then
  m2:note_on(note, vel, 2)
    clock.run(kill_note, note, vel)
  end
end

function play_sequence(seq, voice)
  while true do
    for i=1, #seq do
      if seq[i] == 1 then
        local note_val = utils.percentageChance(20) and 
          (voices[voice]["note"] + utils.randomOctave()) or 
          voices[voice]["note"]
        play_note(note_val, voices[voice]["velocity"], clock)
        voice_status[voice] = "*"
      else
        voice_status[voice] = "_"
      end
      redraw()
      
      if grid_lock == true then
        clock.sync(1 / clock_division)
      else 
        clock.sleep(clock.get_beat_sec() / clock_division)
      end
    end
  end
end

function release_note(k)
  clock.cancel(voices[k]["clock"])
  voices[k]["available"] = true
  voices[k]["velocity"] = nil
  voices[k]["note"] = nil
  voices[k]["hold_release"] = nil
  voice_status[k] = "_"
  redraw()
end

function hold_release()
  for k, v in pairs(voices) do
    if v["hold_release"] == true then
      release_note(k)
    end
  end
end

function toggle_shift()
  shift = not shift
  redraw()
end

function toggle_hold()
  hold = not hold
  redraw()
end

function toggle_output()
  if output_mode == 0 then
    output_mode = 1
  else
    output_mode = 0
  end
  redraw()
end

-- midi things
m1.event = function(data)
  local d = midi.to_msg(data)

  -- note on things
  if d.type == "note_on" then
    voice_space = utils.find_empty_space(voices)
    voice_sequence = sequences[voices[voice_space]["sequence"]]
    voices[voice_space]["note"] = d.note
    voices[voice_space]["available"] = false
    voices[voice_space]["velocity"] = d.vel
    voices[voice_space]["clock"] = clock.run(play_sequence, voice_sequence ,voice_space)
  elseif d.type == "note_off" then
  
    -- note off things
    for k, v in pairs(voices) do
      if v["note"] == d.note then
        if hold == false then
          -- if hold isn't on, kill the voice
          release_note(k)
        else
          -- or else mark the voice to be released when hold turned off
          voices[k]["hold_release"] = true
        end
      end
    end
  end
end

function key(n,z)
  -- key actions: n = number, z = state
  -- shift button
  if n==1 then
    toggle_shift()
  end

  -- toggle hold
  if n==2 and z==1 then
    toggle_hold()
  end

  -- toggle internal synth
  if n==3 and z==1 then
      toggle_output()
  end
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    -- swtich mode to settings screen and back
    page = util.clamp(d, 0, 1)
    redraw()
  end

  -- select active selected
  if n == 2 then
    selected = util.clamp(selected + d, 1, #voices)
    redraw()
  end

  -- select active selected
  if n == 3 then
    voices[selected].sequence = util.clamp(voices[selected].sequence + d, 1, #sequences)
    redraw()
  end
end

function redraw()
  screen.clear()

  -- main screen
  if page == 0 then 
    interface.draw_gate(output_mode)
    interface.draw_hold(hold)
    interface.draw_activity(voices, voice_status)
    interface.draw_sequences(selected, voices)

  -- settings screen
  elseif page == 1 then
    interface.draw_settings(shift)
  end

  screen.update()
end

function init()
  -- initialization stuff
end

function cleanup()
  -- deinitialization
end