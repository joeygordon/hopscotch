-- Strata
--
-- -------------------------------
--
-- v0.1.0 by @joeygordon
-- link to lines eventually

engine.name = 'PolyPerc'
m1 = midi.connect(1)
m2 = midi.connect(2)
music = require 'musicutil'
utils = include 'lib/utils'
interface = include 'lib/interface'
voices = include 'lib/voices'
sequences = include 'lib/sequences'
encoder_actions = include 'lib/encoder_actions'
key_actions = include 'lib/key_actions'

voice_status = { "_", "_", "_", "_", "_", "_", "_", "_" }
page = 0
selected = 1
hold = false
shift = false
clock_division = 4
grid_lock = true
output_mode = 1
gate_length = 0.5

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
  if hold == false then
    hold_release()
  end
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

  -- note off things
  elseif d.type == "note_off" then
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
  key_actions.init(n,z)
end

function enc(n,d)
  encoder_actions.init(n,d)
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
  engine.cutoff(1000)
end

function cleanup()
  -- deinitialization
end