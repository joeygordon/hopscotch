-- do things when you turn the encoders

local encoder_actions = {}

function encoder_actions.init(n,d)
  -- encoder actions: n = number, d = delta

  -- swtich page to settings screen and back
  -- if n == 1 then
  --   pages:set_index_delta(d, false)
  -- end

  -- select active selected
  if n == 2 then
    selected = util.clamp(selected + d, 1, #voices + 2)
  end

  -- choose sequence/channel
  if n == 3 then
    if shift == true and params:get('hs_output') == 1 then
      params:set(
        "hs_v"..selected.."_channel", 
        util.clamp(params:get("hs_v"..selected.."_channel") + d, 1, 16)
      )
    elseif selected <= #voices then
      params:set(
        "hs_v"..selected.."_sequence", 
        util.clamp(params:get("hs_v"..selected.."_sequence") + d, 1, #sequences)
      )
    elseif selected == #voices + 1 then
      params:set(
        "hs_clock_division",
        util.clamp(params:get("hs_clock_division") + d, 1, #clock_div_options)
      )
    else
      params:set(
        "hs_gate_length",
        util.clamp(params:get("hs_gate_length") + d, 1, #gate_options)
      )
    end
  end

  redraw()
end

return encoder_actions