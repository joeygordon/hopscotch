-- do stuff with midi

local strata_midi = {}

function kill_note(note, vel, channel)
  clock.sleep(
    (clock.get_beat_sec() / clock_div_values[params:get('strata_clock_division')]) * 
    gate_values[params:get('strata_gate_length')]
  )
  midi_out:note_off(note, vel, channel)
end

function strata_midi.play(note, vel, channel)
  midi_out:note_on(note, vel, channel)
  clock.run(kill_note, note, vel, channel)
end

function strata_midi.kill_all()
  for k, v in pairs(voices) do
    if v.available == false then
      clock.cancel(voices[k]["clock"])
      voices[k].available = true
      midi_out:note_off(v.note, 100, params:get('strata_v'..k..'_channel'))
    end
  end
end

function strata_midi.note_on()
  local voice_space = utils.find_empty_space(voices)

  if voice_space ~= false then
    voice_sequence = sequences[params:get('strata_v'..voice_space..'_sequence')]
    if voice_sequence.steps == nil then
      local random_i = math.random(1, #sequences - 1)
      voice_sequence = sequences[random_i]
    end
    voices[voice_space]["note"] = d.note
    voices[voice_space]["available"] = false
    voices[voice_space]["clock"] = clock.run(play_sequence, voice_sequence.steps ,voice_space, d.vel)
    end
end

function strata_midi.note_off()
  for k, v in pairs(voices) do
    if v["note"] == d.note then
      if params:get('strata_hold') == 0 then
        -- if hold isn't on, kill the voice
        release_note(k)
      else
        -- or else mark the voice to be released when hold turned off
        voices[k]["hold_release"] = true
      end
    end
  end
end

return strata_midi