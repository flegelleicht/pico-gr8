pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- ⬅️➡️⬆️⬇️❎🅾️

local cursor
local explosions
local targets

local max_chain = 0
local max_simultaneous = 0

function _init()

  cursor = {
    x = 64,
    y = 64,
    c = 7,
    s = 3,
    update = function(self) 
    	if btn(➡️) then
    		self.x += self.s
        if self.x >= 127 then
          self.x = 127
        end
    	end
    	if btn(⬅️) then
    		self.x -= self.s
        if self.x <= 0 then
          self.x = 0
        end
    	end
    	if btn(⬆️) then
    		self.y -= self.s
        if self.y <= 0 then
          self.y = 0
        end
    	end
      if btn(⬇️) then
        self.y += self.s
        if self.y >= 127 then
          self.y = 127 
        end
      end
      if btnp(❎) then
        -- thisx = self.x
        -- thisy = self.y
        explosions:explode(self.x, self.y)
      end
    end,
    draw = function(self)
      pset(self.x, self.y, self.c)
    end,
  }
  
  explosions = {
    e = {},
    update = function(self)
      local expl
      for expl in all(self.e) do
        expl:update()
      end
      
      if #self.e > max_simultaneous then
        max_simultaneous = #self.e
      end
    end,
    draw = function(self)
      local expl
      for expl in all(self.e) do
        expl:draw()
      end
    end,
    explode = function(self,x, y)
      local expl = make_explosion(x,y)
      add(self.e,expl)
      sfx(0)
    end,
    explode = function(self, x, y, chain)
      local expl = make_explosion(x,y)
      if chain then
        expl.chain = chain + 1
        if expl.chain > max_chain then
          max_chain = expl.chain
        end
      else
        expl.chain = 0
      end
      add(self.e,expl)
      sfx(0)
    end,
    remove = function(self, expl)
      del(self.e, expl)
    end,
    any_hits = function(self, target)
      local expl
      local minimum = 70
      local result = nil
      for expl in all(self.e) do
        local hit = expl:hits(target)
        if hit then
          if hit.dist < minimum then
            result = hit
            minimum = hit.dist
          end
        end
      end
      
      if result then
        return result
      else
        return false
      end
    end,
  }

  targets = {
    t = {},
    spawn_rate = 20,
    spawn_timer = 0,
    update = function(self)
      local target
      for target in all(self.t) do
        target:update()
      end
      
      self.spawn_timer += 1
      if self.spawn_timer >= self.spawn_rate then
        self.spawn_timer = flr(rnd(45))
        add(self.t, make_target())
      end
    end,
    draw = function(self)
      local target
      for target in all(self.t) do
        target:draw()
      end
    end,
    remove = function(self, t)
      del(self.t, t)
    end,
  }
end

function _update()
  cursor:update()
  explosions:update()
  targets:update()
end

function _draw()
	cls()
  --print(#explosions.e, 5,5, 7)
  --print(#targets.t, 5,15, 7)
  print("max chain:" .. max_chain, 5,5, 7)
  print("max sim:" .. max_simultaneous, 5,12, 7)
  targets:draw()
  explosions:draw()
  cursor:draw()
end

function make_explosion(x, y)  
  local expl = {
    x = x,
    y = y,
    r = 5,
    c = 8,
    t = {},
    rl = 25,
    chain = 0,
    update = function(self)
      if self.r < self.rl then
        self.r += 1
      end
      if self.r >= self.rl then
        explosions:remove(self)
      end
    end,
    draw = function(self)
      -- pset(self.x, self.y, 7)
      circ(self.x, self.y, self.r, self.c)
      print(self.chain, self.x, self.y, 7)
      -- local target
      -- for target in all(self.t) do
      --   line(self.x, self.y, target.x, target.y, 12)
      -- end
    end,
    hits = function(self, target)
      local dx = self.x - target.x
      local dy = self.y - target.y
      local l = sqrt(dx*dx + dy*dy)
      if l <= self.r + 7 then -- FIXME: Magic Numer
        add(self.t,target)
        return { chain = self.chain, dist = l }--self
      else
        return nil
      end
    end,
  }
  return expl
end

function make_target()
  local t = {
    spawn_x = 0,
    spawn_y = 0,
    x = 0,
    y = 0,
    dx = 0,
    dy = 0,
    r = 7,
    c = 2,
    z = 0,
    s = between(0.5, 3),
    update = function(self)
      if self.z == 0 then
        self.z = 1
        
        local spawn_sector = flr(rnd(8))
        if     spawn_sector == 0 then
          self.x = between(-10, -7)
          self.y = between(0, 127)
        elseif spawn_sector == 1 then
          self.x = between(-10, -7)
          self.y = between(-10, -7)
        elseif spawn_sector == 2 then
          self.x = between(0, 127)
          self.y = between(-10, -7)
        elseif spawn_sector == 3 then
          self.x = between(127, 134)
          self.y = between(-10, -7)
        elseif spawn_sector == 4 then
          self.x = between(127, 134)
          self.y = between(0, 127)
        elseif spawn_sector == 5 then
          self.x = between(127, 134)
          self.y = between(127, 134)
        elseif spawn_sector == 6 then
          self.x = between(0, 127)
          self.y = between(127, 134)
        elseif spawn_sector == 7 then
          self.x = between(-10, -7)
          self.y = between(127, 134)
        else 
          self.x = 64
          self.y = 64
        end
        
        -- self.x = -7
        -- self.y = rnd(141) - 7
        self.spawn_x = self.x
        self.spawn_y = self.y

        local vx = 64 - self.x
        local vy = 64 - self.y

        self.dx = (vx / (sqrt(vx*vx+vy*vy))) * self.s
        self.dy = (vy / (sqrt(vx*vx+vy*vy))) * self.s
        
        --printh("" .. self.x .. " " .. self.y .. " " .. self.dx .. " " .. self.dy .. "\n", "log.txt")
      end

      self.x += self.dx
      self.y += self.dy
      
      local expl = explosions:any_hits(self)
      if expl then
        targets:remove(self)
        explosions:explode(self.x, self.y, expl.chain)
      end
      
      local dist = distance(self.spawn_x, self.spawn_y, self.x, self.y)
      if flr(dist) > 160 then
        targets:remove(self)
      end
      
    end,
    draw = function(self)
      if self.z ~= 0 then
        circfill(self.x, self.y, self.r, self.c)
        --print(flr(distance(self.spawn_x, self.spawn_y, self.x, self.y)), self.x, self.y, 7)
        -- print(self.s, self.x, self.y, 7)
      end
    end,
  }
  return t
end

function between(low, high)
  local spread = high - low
  local val = (rnd(1) * spread) + low
  return val
end

function distance(x1, y1, x2, y2)
  local dx = x1 - x2
  local dy = y1 - y2
  local l  = sqrt(dx*dx+dy*dy)
  -- printh("distance " .. x1 .. "|" .. y1 .. " " .. x2 .. "|" .. y2 ..": " .. l, "log.txt")
  
  return l
end

__sfx__
0001000006650096500b6500c6500d6500e6501065012650136501365013650136501365013650136501365013650136501265012650126501165011650106500f6500e6500d6500c6500a650076500365000000
