pico-8 cartridge // http://www.pico-8.com
version 16
__lua__


function make_smoke(x, y, init_size, c)
  local s = {}
  s.x = x
  s.y = y
  s.c = c
  s.w = init_size
  s.max_w = init_size + rnd(3) + 1
  s.t = 0
  s.max_t = 30 + rnd(10)
  s.dx = (rnd(1) < .5) and rnd(.08) or -rnd(.08)
  s.dy = -rnd(.5)
  s.ddy = -.02
  add(smoke, s)
  return s
end

function move_smoke(sp)
  if(sp.t > sp.max_t) then
    del(smoke, sp)
  end
  if(sp.t>sp.max_t-15) then
    sp.w += 1
    sp.w = min(sp.w, sp.max_w)
  end
  sp.x = sp.x + sp.dx
  sp.y = sp.y + sp.dy
  sp.dy = sp.dy + sp.ddy
  sp.t = sp.t + 1
end

function _init()
  smoke = {}
  cx = 50
  cy = 50
  c = 7
  
  player = {
    update = function(self) 
    	if btn(➡️) then
    	end
    	if btn(⬅️) then
    	end
    	if btn(⬆️) then
    	end
      if btn(⬇️) then
      end
      if btnp(❎) then
      end
      if btnp(🅾️) then
      end
    end,

    draw = function(self)
    end,
  }
end

function _update()
  foreach(smoke, move_smoke)
  if btn(0,0) then cx-=1 end
  if btn(1,0) then cx+=1 end
  if btn(2,0) then cy-=1 end
  if btn(3,0) then cy+=1 end
  if btn(4,0) then c = flr(rnd(16)) end
  make_smoke(cx, cy, rnd(4), c)
  player:update()
end

function draw_smoke(s)
  circfill(s.x, s.y, s.w, s.c)
end

function _draw()
  cls()
  foreach(smoke, draw_smoke)
  player:draw()
end
