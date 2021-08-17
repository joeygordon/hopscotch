-- send outputs to JF via crow

local hs_jf = {}

local function kill_note(note, voice, skip_clock)
  if skip_clock == false then
    clock.sleep(
      (clock.get_beat_sec() / clock_div_values[params:get('hs_clock_division')]) * 
        gate_values[params:get('hs_gate_length')]
    )
  end
  
  crow.ii.jf.play_voice( voice, note, 0)
end

function hs_jf.play(note, vel, voice)
  local level = (vel / 127) * 10
  local pitch = note / 12
  crow.ii.jf.play_voice(voice, pitch, level)
  clock.run(kill_note, pitch, voice)
end

return hs_jf