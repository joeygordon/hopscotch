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

local sequence = {true, true, false, true, false, true, true, false, "loop"}

function firstSequence(seq)
  -- this will not last
  i = 1

  while true do
    clock.sync(1/4)
    print(seq[i])
    if i == #seq then
      i = 1
    else
      i = i + 1
    end

    -- for i=1,#seq do
    --   clock.sync(1/4)
    --   -- engine.hz(i*100)
    --   print(seq[i])
    --   if i == #seq
    -- end
  end
end

function init()
  -- initialization stuff
end

function key(n,z)
  -- key actions: n = number, z = state
  if n==3 and z==1 then
    main_clock = clock.run(firstSequence, sequence)
  end

  if n==2 and z==1 then
    clock.cancel(main_clock)
  end
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
end

function redraw()
  -- screen redraw
  screen.clear()
  screen.move(10,10)
  screen.text("k3 to start sequence")
  screen.move(10, 25)
  screen.text("k2 to stop sequence")
  screen.update()
end

function cleanup()
  -- deinitialization
end