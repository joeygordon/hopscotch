local utils = {}

function utils.percentageChance(percent)
  return percent >= math.random(1, 100)
end

function utils.randomOctave()
  chance = math.random(0,1)
  if chance == 0 then
    return -12
  else
    return 12
  end
end


return utils