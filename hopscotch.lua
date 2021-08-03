-- Hopscotch
--
-- -------------------------------
--
-- E2: select parameter
-- E3: adjust parameter
-- K1: shift - midi channels
-- K3: hold on/off
--
-- -------------------------------
--
-- v1.0.0 by @joeygordon

engine.name = 'PolyPerc'

music = require 'musicutil'
ui = require 'ui'

parameters = include 'lib/parameters'
utils = include 'lib/utils'
interface = include 'lib/interface'
hs_midi = include 'lib/midi'
voices = include 'lib/voices'
sequences = include 'lib/sequences'
encoder_actions = include 'lib/encoder_actions'
key_actions = include 'lib/key_actions'
glyphs = include 'lib/glyphs'

midi_in = midi.connect(1)
midi_out = midi.connect(2)
pages = ui.Pages.new(1, 2)
selected = 1
shift = false
voice_status = { 0, 0, 0, 0, 0, 0, 0, 0 }
clock_div_options = {'1/32', '1/16', '1/12', '1/8', '1/6', '1/4', '1/3', '1/2', '1'}
clock_div_values = {32, 16, 12, 8, 6, 4, 3, 2, 1}
gate_options = {'10%', '25%', '33%', '50%', '66%', '75%', '90%', '100%'}
gate_values = {0.10, 0.25, 0.333, 0.5, 0.666, 0.75, 0.9, 1}

-- toggle settings

function toggle_shift()
  shift = not shift
  redraw()
end

function toggle_hold()
  if params:get('hs_hold') == 1 then
    params:set('hs_hold', 0)
    hold_release()
  else
    params:set('hs_hold', 1)
  end
  redraw()
end

function toggle_output()
  if params:get('hs_output') == 1 then
    params:set('hs_output', 2)
  else
    params:set('hs_output', 1)
  end 
  redraw()
end

-- play sounds

function play_note(note, vel, channel)
  if params:get('hs_output') == 1 then
    -- midi output
    hs_midi.play(note, vel, channel)
  elseif params:get('hs_output') == 2 then
    -- internal output
    engine.amp(vel / 127)
    engine.hz(music.note_num_to_freq(note))
  end
end

function play_sequence(seq, voice, vel)
  while true do
    for i=1, #seq do
      if seq[i] == 1 then
        local note_val = utils.percentageChance(20) and 
          (voices[voice]["note"] + utils.randomOctave()) or 
          voices[voice]["note"]
        play_note(
          note_val, 
          vel, 
          params:get('hs_v'..voice..'_channel')
        )
        voice_status[voice] = 1
      else
        voice_status[voice] = 0
      end
      redraw()
      
      if params:get('stata_grid_lock') == 1 then
        clock.sync(1 / clock_div_values[params:get('hs_clock_division')])
      else 
        clock.sleep(clock.get_beat_sec() / clock_div_values[params:get('hs_clock_division')])
      end
    end
  end
end

function release_note(k)
  clock.cancel(voices[k]["clock"])
  voices[k]["available"] = true
  voices[k]["note"] = nil
  voices[k]["hold_release"] = nil
  voice_status[k] = 0
  redraw()
end

function hold_release()
  for k, v in pairs(voices) do
    if v["hold_release"] == true then
      release_note(k)
    end
  end
end

-- midi things

midi_in.event = function(data)
  local d = midi.to_msg(data)

  if d.type == "note_on" then
    hs_midi.note_on()
  elseif d.type == "note_off" then
    hs_midi.note_off()
  end
end

-- interface things

function key(n,z)
  key_actions.init(n,z)
end

function enc(n,d)
  encoder_actions.init(n,d)
end

function redraw()
  screen.clear()

  -- main screen
  if pages.index == 1 then 
    interface.draw_clock_div()
    interface.draw_gate()
    interface.draw_hold()
    interface.draw_activity()
    if shift == true then
      interface.draw_channels()
    else
      interface.draw_sequences()
    end

  -- settings screen
  elseif pages.index == 2 then
    interface.draw_settings()
  end

  screen.update()
end

function init()
  engine.cutoff(1000)

  norns.enc.sens(1,16)
  norns.enc.sens(2,16)
  norns.enc.sens(3,16)

  -- load params
  parameters.init()
  
  midi_in = midi.connect(params:get('hs_midi_input'))
  midi_out = midi.connect(params:get('hs_midi_output'))
end

function cleanup()
  params:write()
  hs_midi.kill_all()
end
