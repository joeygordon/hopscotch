-- params

local parameters = {}

function get_midi_devices()
  local d = {}
  for k, v in pairs(midi.vports) do
      d[k] = v.name
  end
  return d
end

function parameters.init() 
  params:add_separator('Hopscotch')
  -- misc
  params:add_binary('hs_hold', 'Hold', 'toggle', 0)
  params:hide('hs_hold')
  params:add_option('hs_output', 'Output Device', {'midi', 'internal'}, 1)
  params:add_option('hs_clock_division', 'Clock Division', clock_div_options, 6)
  params:add_option('hs_gate_length', 'Gate Length', gate_options, 4)
  params:add_binary('hs_grid_lock', 'Lock to Grid', 'toggle', 1)
  -- params:add_option('hs_midi_input', 'Input', get_midi_devices(), 1)
  -- params:add_option('hs_midi_output', 'Output', get_midi_devices(), 2)

  -- voice sequences
  params:add_option('hs_v1_sequence', 'Voice 1 Sequence', {1, 2, 3, 4, 5, 6, 7, 8, 9}, 1)
  params:add_option('hs_v2_sequence', 'Voice 2 Sequence', {1, 2, 3, 4, 5, 6, 7, 8, 9}, 2)
  params:add_option('hs_v3_sequence', 'Voice 3 Sequence', {1, 2, 3, 4, 5, 6, 7, 8, 9}, 3)
  params:add_option('hs_v4_sequence', 'Voice 4 Sequence', {1, 2, 3, 4, 5, 6, 7, 8, 9}, 4)
  params:add_option('hs_v5_sequence', 'Voice 5 Sequence', {1, 2, 3, 4, 5, 6, 7, 8, 9}, 5)
  params:add_option('hs_v6_sequence', 'Voice 6 Sequence', {1, 2, 3, 4, 5, 6, 7, 8, 9}, 6)
  params:add_option('hs_v7_sequence', 'Voice 7 Sequence', {1, 2, 3, 4, 5, 6, 7, 8, 9}, 7)
  params:add_option('hs_v8_sequence', 'Voice 8 Sequence', {1, 2, 3, 4, 5, 6, 7, 8, 9}, 8)
  params:hide('hs_v1_sequence')
  params:hide('hs_v2_sequence')
  params:hide('hs_v3_sequence')
  params:hide('hs_v4_sequence')
  params:hide('hs_v5_sequence')
  params:hide('hs_v6_sequence')
  params:hide('hs_v7_sequence')
  params:hide('hs_v8_sequence')

  -- midi channels
  params:add_group('MIDI Channels', 8)
  params:add_option('hs_v1_channel', 'Voice 1 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('hs_v2_channel', 'Voice 2 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('hs_v3_channel', 'Voice 3 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('hs_v4_channel', 'Voice 4 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('hs_v5_channel', 'Voice 5 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('hs_v6_channel', 'Voice 6 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('hs_v7_channel', 'Voice 7 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  params:add_option('hs_v8_channel', 'Voice 8 Channel', {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, 1)
  
  params:read()
end

return parameters