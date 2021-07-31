-- Strata
--
-- -------------------------------
--
-- v0.1.0 by @joeygordon
-- link to lines eventually

engine.name = 'PolyPerc'

music = require 'musicutil'
ui = require 'ui'

parameters = include 'lib/parameters'
utils = include 'lib/utils'
interface = include 'lib/interface'
voices = include 'lib/voices'
sequences = include 'lib/sequences'
encoder_actions = include 'lib/encoder_actions'
key_actions = include 'lib/key_actions'
glyphs = include 'lib/glyphs'

midi_in = midi.connect(1) -- midi input device
midi_out = midi.connect(2) -- midi output device
voice_status = { 0, 0, 0, 0, 0, 0, 0, 0 }
pages = ui.Pages.new(1, 2)
selected = 1
shift = false
grid_lock = true
clock_div_options = {'1/32', '1/16', '1/8', '1/4', '1/2', '1'}
clock_div_values = {32, 16, 8, 4, 2, 1}
gate_length = 0.5
gate_options = {'10%', '25%', '33%', '50%', '66%', '75%', '100%'}
gate_values = {0.10, 0.25, 0.333, 0.5, 0.666, 0.75, 1}

function kill_note(note, vel)
  clock.sleep(clock.get_beat_sec() / (params:get('strata_clock_division') * gate_values[params:get('strata_gate_length')]))
  midi_out:note_off(note, vel, 2)
end

function play_note(note, vel, channel)
  if params:get('strata_output') == 'internal' then
    engine.amp(vel / 127)
    engine.hz(music.note_num_to_freq(note))
  elseif params:get('strata_output') == 'midi' then
    midi_out:note_on(note, vel, channel)
    clock.run(kill_note, note, vel)
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
          params:get('strata_v'..voice..'channel')
        )
        voice_status[voice] = 0
      else
        voice_status[voice] = 1
      end
      redraw()
      
      if grid_lock == true then
        clock.sync(1 / params:get('strata_clock_division'))
      else 
        clock.sleep(clock.get_beat_sec() / params:get('strata_clock_division'))
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

function toggle_shift()
  shift = not shift
  redraw()
end

function toggle_hold()
  if params:get('strata_hold') == 1 then
    params:set('strata_hold', 0)
    hold_release()
  else
    params:set('strata_hold', 1)
  end
  redraw()
end

function toggle_output()
  if params:get('strata_output') == 1 then
    params:set('strata_output', 2)
  else
    params:set('strata_output', 1)
  end 
  redraw()
end

-- midi things
midi_in.event = function(data)
  local d = midi.to_msg(data)

  -- note on things
  if d.type == "note_on" then
    voice_space = utils.find_empty_space(voices)
    voice_sequence = sequences[params:get('strata_v'..voice_space..'_sequence')]
    voices[voice_space]["note"] = d.note
    voices[voice_space]["available"] = false
    voices[voice_space]["clock"] = clock.run(play_sequence, voice_sequence.steps ,voice_space, d.vel)

  -- note off things
  elseif d.type == "note_off" then
    for k, v in pairs(voices) do
      if v["note"] == d.note then
        if params:get('strata_hold') == false then
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
  -- initialization stuff
  engine.cutoff(1000)

  norns.enc.sens(1,6)
  norns.enc.sens(2,6)
  norns.enc.sens(3,6)

  -- params
  parameters.init()
end

function cleanup()
  -- deinitialization
  params:write()
  -- TODO kill all voices
end
