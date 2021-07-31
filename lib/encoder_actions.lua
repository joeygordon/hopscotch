local encoder_actions = {}

function encoder_actions.init(n,d)
  -- encoder actions: n = number, d = delta
  -- swtich mode to settings screen and back
  if n == 1 then
    pages:set_index_delta(d, false)
  end

  -- select active selected
  if n == 2 then
    selected = util.clamp(selected + d, 1, #voices)
  end

  -- select active selected
  if n == 3 then
    params:set(
      "strata_v"..selected.."_sequence", 
      util.clamp(params:get("strata_v"..selected.."_sequence") + d, 1, #sequences)
    )
  end

  redraw()
end

return encoder_actions