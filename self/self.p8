pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

local state = {}

function _init()
  state.go = false;
  state.c = 7
  state.s = {}
  state.t = 64
  state.l = 64
  state.rx = 10
  state.ry = 10
  for x = 0, 127, 1 do
    state.s[x] = {}
    for y = 0, 127, 1 do
      state.s[x][y] = 13
    end
  end
  state.r = {}
  for x = 0, 127, 1 do
    state.r[x] = {}
    for y = 0, 127, 1 do
      state.r[x][y] = 14
    end
  end
end

function get()
  for x = 0, 127, 1 do
    state.s[x] = {}
    for y = 0, 127, 1 do
      state.s[x][y] = pget(x, y)
    end
  end
end

function set()
  for x = 0, 127, 1 do
    for y = 0, 127, 1 do
      pset(x, y, state.r[x][y])
    end
  end  
end

function rot(a, s)
  for x = 0, 127, 1 do
    for y = 0, 127, 1 do
      local u = flr( cos(-a) * (x - state.l) + sin(-a) * (y - state.t) + 0.5) + state.l;
      local v = flr(-sin(-a) * (x - state.l) + cos(-a) * (y - state.t) + 0.5) + state.l;
      -- printh("x:" .. x .."->u:" .. u .. ", y:" .. y.."->v:" .. v)
      if (0 <= u) and (u < 128) and (0 <= v) and (v < 128) then
        state.r[x][y] = state.s[u][v];
      else
        state.r[x][y] = 0;
      end
    end
  end
end

function trl(dx, dy)
  local x, y
  for x = 0, 127, 1 do
    for y = 0, 127, 1 do
      local u = x + dx;
      local v = y + dy;
      if (0 <= u) and (u < 128) and (0 <= v) and (v < 128) then
        -- printh("IN u: " .. u .. ", v: " .. v)
        state.r[x][y] = state.s[u][v];
      else
        -- printh("OU u: " .. u .. ", v: " .. v)
        state.r[x][y] = 0;
      end
    end
  end
end


-- ⬅️➡️⬆️⬇️❎🅾️

function _update()
  state.c = flr(rnd(8))
  if(state.go) then
    printh("get")
    get();
    printh("rot")
    rot(0.02, 1.0)
  end
  
  if btnp(⬆️) then
    printh("btnp")
    get();
    rot(0.01, 1.0);
    state.go = true;
  end
  if btn(⬆️) then
    state.ry -= 5
  end
  if btn(⬇️) then
    state.ry += 5
  end
  
  if btn(➡️) then
    state.l += 2
  end
  if btn(⬅️) then
    state.l -= 2
  end
  
  
end

function _draw()
  cls(flr(rnd(16)));
  if(state.go) then
    printh("_set")
    set();
  end
  
  rect(state.rx,state.ry, state.rx+10, state.ry + 10, 8);
  rectfill(state.rx+1,state.ry+1, state.rx+10-1, state.ry+10-1, 7);
  

end
