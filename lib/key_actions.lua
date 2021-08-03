-- do things when you press the buttons

local key_actions = {}

function key_actions.init(n,z)
  -- shift button
  if n==1 then
    toggle_shift()
  end
  
  -- toggle internal synth
  if n==3 and z==1 then
    toggle_hold()
  end
end

return key_actions