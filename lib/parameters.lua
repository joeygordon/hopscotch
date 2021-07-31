-- params

------------------------------
-- notes and todo lsit
--
-- note: pretty normal params stuff
--
-- todo list: 
--  figure out default params
--  do i actually need any param actions?
------------------------------

local parameters = {}

function parameters.init() 
  params:add_separator('Strata')
  params:add_binary('strata_hold', 'hold', 'toggle')
  params:add_option('strata_output', 'Output Device', {'midi', 'internal'}, 1)
  params:add_option('strata_gate_length', 'Gate Length', gate_options, 4)
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

return parameters