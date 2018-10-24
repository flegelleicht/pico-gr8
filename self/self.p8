pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

local state = {}

function _init()
  state.c = 7
  state.s = {}
end

function get()
  for y = 0, 127, 1 do
    state.s[y] = {}
    for x = 0, 127, 1 do
      state.s[y][x] = pget(x, y)
    end
  end
end

function set()
  for y = 0, 127, 1 do
    state.s[y] = {}
    for x = 0, 127, 1 do
      pset(x, y, state.s[y][x])
    end
  end  
end

function _update()
  state.c = flr(rnd(16))
  get()
end

function _draw()
  cls()
  pal(0, state.c)
  set()
end
