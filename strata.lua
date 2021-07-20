--
-- Strata
-- big-time Stratus ripoff
-- (for now)
--
-- -----------------------
--
-- v0.1.0 by @joeygordon
-- link to lines eventually

engine.name = 'PolySub'

local sequences = include("lib/sequences")

local voices = {
  {},
  {},
  {},
  {},
  {},
}

local key_voice_index = {}
local next = next

function play_sequence(seq, voice)
  i = 1
  while true do
    clock.sync(1/4)
    print(seq[i])
    if i == #seq then
      i = 1
    else
      i = i + 1
    end
  end
end

function find_empty_space()
  -- cycle through voices and return first available voice
  for k, v in pairs(voices) do
    if next(voices[k]) == nil then
      print('voice found')
      return k
    end
  end
  return false
end


function init()
  -- initialization stuff
end

function key(n,z)
  -- key actions: n = number, z = state
  if n==3 or n==2 then
    if z==1 then
      voice_space = find_empty_space()

      if voice_space ~= false then
        print(voice_space)
        voices[voice_space] = clock.run(play_sequence, sequences[1], voice_space)
        key_voice_index[n] = voice_space
      end
    else
      voice_space_index = key_voice_index[n]

      if voice_space_index ~= nil then
        clock.cancel(voices[voice_space_index])
        key_voice_index[n] = nil
        voices[voice_space_index] = {}
      end
    end
  end
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
end

function redraw()
  -- screen redraw
  screen.clear()
  screen.move(10,10)
  screen.text("press a key to start")
  screen.move(10, 25)
  screen.text("release to stop")
  screen.update()
end

function cleanup()
  -- deinitialization
end