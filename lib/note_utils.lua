-- things that help with managing the state of notes

hs_midi = include 'lib/midi'
hs_jf = include 'lib/crow'

local note_utils = {}

function note_utils.release_note(k)
  clock.cancel(voices[k]["clock"])
  voices[k]["available"] = true
  voices[k]["note"] = nil
  voices[k]["hold_release"] = nil
  voice_status[k] = 0
  redraw()
end

function note_utils.play_note(note, vel, channel, voice)
  if params:get('hs_output') == 1 then
    -- midi output
    hs_midi.play(note, vel, channel)
  elseif params:get('hs_output') == 2 then
    -- internal output
    engine.amp(vel / 127)
    engine.hz(music.note_num_to_freq(note))
  elseif params:get('hs_output') == 3 then
    -- JF output
    hs_jf.play(note, vel, voice)
  end
end

function note_utils.kill_all()
  for k, v in pairs(voices) do
    if v.available == false then
      clock.cancel(voices[k]["clock"])
      voices[k].available = true
      if params:get('hs_output') == 1 then
        hs_midi.kill_note(v.note, 100, params:get('hs_v'..k..'_channel'), true)
      elseif params:get('hs_output') == 3 then
        hs_jf.kill_note(v.note, params:get('hs_v'..k..'_channel'), true)
      end
    end
  end
end

return note_utils