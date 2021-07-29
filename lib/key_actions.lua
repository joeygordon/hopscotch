local key_actions = {}

function key_actions.init(n,z)
  -- key actions: n = number, z = state
  -- shift button
  if n==1 then
    toggle_shift()
  end

  -- toggle hold
  if n==2 and z==1 then
    toggle_output()
  end
  
  -- toggle internal synth
  if n==3 and z==1 then
    toggle_hold()
  end
end

return key_actions