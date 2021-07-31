-- Strata
--
-- -------------------------------
--
-- v0.1.0 by @joeygordon
-- link to lines eventually

engine.name = 'PolyPerc'

music = require 'musicutil'
ui = require 'ui'

utils = include 'lib/utils'
interface = include 'lib/interface'
voices = include 'lib/voices'
sequences = include 'lib/sequences'
encoder_actions = include 'lib/encoder_actions'
key_actions = include 'lib/key_actions'

midi_in = midi.connect(1) -- midi input device
midi_out = midi.connect(2) -- midi output device
voice_status = { "_", "_", "_", "_", "_", "_", "_", "_" }
pages = ui.Pages.new(1, 2)
selected = 1
shift = false
clock_division = 4
grid_lock = true
gate_length = 0.5

function kill_note(note, vel)
  clock.sleep(clock.get_beat_sec() / (clock_division * 2))
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
    voices[voice_space]["clock"] = clock.run(play_sequence, voice_sequence ,voice_space, d.vel)

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
    interface.draw_gate()
    interface.draw_hold()
    interface.draw_activity(voices, voice_status)
    if shift == true then
      interface.draw_channels()
    else
      interface.draw_sequences(selected, voices)
    end

  -- settings screen
  elseif pages.index == 2 then
    interface.draw_settings(shift)
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
  params:add_separator('Strata')
  params:add_binary('strata_hold', 'hold', 'toggle')
  params:add_option('strata_output', 'Output Device', {'midi', 'internal'}, 1)
  -- params:add_group('Sequences', 8)
  params:add_option('strata_v1_sequence', 'Voice 1 Sequence', {1, 2, 3, 4, 5, 6, 7, 8}, 1)
  params:add_option('strata_v2_sequence', 'Voice 2 Sequence', {1, 2, 3, 4, 5, 6, 7, 8}, 2)
  params:add_option('strata_v3_sequence', 'Voice 3 Sequence', {1, 2, 3, 4, 5, 6, 7, 8}, 3)
  params:add_option('strata_v4_sequence', 'Voice 4 Sequence', {1, 2, 3, 4, 5, 6, 7, 8}, 4)
  params:add_option('strata_v5_sequence', 'Voice 5 Sequence', {1, 2, 3, 4, 5, 6, 7, 8}, 5)
  params:add_option('strata_v6_sequence', 'Voice 6 Sequence', {1, 2, 3, 4, 5, 6, 7, 8}, 6)
  params:add_option('strata_v7_sequence', 'Voice 7 Sequence', {1, 2, 3, 4, 5, 6, 7, 8}, 7)
  params:add_option('strata_v8_sequence', 'Voice 8 Sequence', {1, 2, 3, 4, 5, 6, 7, 8}, 8)
  params:hide('strata_v1_sequence')
  params:hide('strata_v2_sequence')
  params:hide('strata_v3_sequence')
  params:hide('strata_v4_sequence')
  params:hide('strata_v5_sequence')
  params:hide('strata_v6_sequence')
  params:hide('strata_v7_sequence')
  params:hide('strata_v8_sequence')
  params:add_group('MIDI Channels', 8)
  params:add_option('strata_v1_channel', 'Voice 1 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('strata_v2_channel', 'Voice 2 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('strata_v3_channel', 'Voice 3 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('strata_v4_channel', 'Voice 4 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('strata_v5_channel', 'Voice 5 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('strata_v6_channel', 'Voice 6 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('strata_v7_channel', 'Voice 7 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('strata_v8_channel', 'Voice 8 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  
  params:read()
end

function cleanup()
  -- deinitialization
  params:write()
end

-- function savestate()
--   local file = io.open(_path.data .. "strata/strat.data", "w+")
--   io.output(file)
--   io.write("v1" .. "\n")
--   for j = 1, 25 do
--     for i = 1, 8 do
--       io.write(memory_cell[j][i].k .. "\n")
--       io.write(memory_cell[j][i].n .. "\n")
--       io.write(memory_cell[j][i].prob .. "\n")
--       io.write(memory_cell[j][i].trig_logic .. "\n")
--       io.write(memory_cell[j][i].logic_target .. "\n")
--       io.write(memory_cell[j][i].rotation .. "\n")
--       io.write(memory_cell[j][i].mute .. "\n")
--     end
--   end
--   io.close(file)
-- end

-- function loadstate()
--   local file = io.open(_path.data .. "foulplay/foulplay-pattern.data", "r")
--   if file then
--     print("datafile found")
--     io.input(file)
--     if io.read() == "v1" then
--       for j = 1, 25 do
--         for i = 1, 8 do
--           memory_cell[j][i].k = tonumber(io.read())
--           memory_cell[j][i].n = tonumber(io.read())
--           memory_cell[j][i].prob = tonumber(io.read())
--           memory_cell[j][i].trig_logic = tonumber(io.read())
--           memory_cell[j][i].logic_target = tonumber(io.read())
--           memory_cell[j][i].rotation = tonumber(io.read())
--           memory_cell[j][i].mute = tonumber(io.read())
--         end
--       end
--     else
--       print("invalid data file")
--     end
--     io.close(file)
--   end
--   for i = 1, 8 do reer(i) end
-- end