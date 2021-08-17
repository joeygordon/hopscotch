-- send outputs to JF via crow

local hs_jf = {}

function hs_jf.stop(note, voice) do 
  clock.sleep(
    (clock.get_beat_sec() / clock_div_values[params:get('hs_clock_division')]) * 
    gate_values[params:get('hs_gate_length')]
  )

  crow.ii.jf.play_voice( voice, note, 0)
end

function hs_jf.play(note, vel, voice) do
  local level = (vel / 127) * 10
  local pitch = note / 12
  crow.ii.jf.play_voice( voice, pitch, level )
  clock.run(kill_note, pitch, voice)
end

function hs_jf.note_off(d)
  for k, v in pairs(voices) do
    if v["note"] == d.note then
      if params:get('hs_hold') == 0 then
        -- if hold isn't on, kill the voice
        release_note(k)
      else
        -- or else mark the voice to be released when hold turned off
        voices[k]["hold_release"] = true
      end
    end
  end
end

return hs_jf