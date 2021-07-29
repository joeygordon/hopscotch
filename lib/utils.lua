local utils = {}

function utils.percentageChance(percent)
  return percent >= math.random(1, 100)
end

function utils.randomOctave()
  local chance = math.random(0,1)
  if chance == 0 then
    return -12
  else
    return 12
  end
end

-- cycle through voices and return first available voice
function utils.find_empty_space(voices)
  for k, v in ipairs(voices) do
    if voices[k]["available"] == true then
      return k
    end
  end
  return false
end


return utils