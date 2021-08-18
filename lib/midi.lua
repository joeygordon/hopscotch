-- do stuff with midi

local hs_midi = {}

function hs_midi.kill_note(note, vel, channel, skip_clock)
  skip_clock = skip_clock or false
  if skip_clock == false then
    clock.sleep(
      (clock.get_beat_sec() / clock_div_values[params:get('hs_clock_division')]) * 
      gate_values[params:get('hs_gate_length')]
    )
  end

  midi_out:note_off(note, vel, channel)
end

function hs_midi.play(note, vel, channel)
  midi_out:note_on(note, vel, channel)
  clock.run(hs_midi.kill_note, note, vel, channel)
end


return hs_midi