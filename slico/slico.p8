pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

local player

function _init()
  player = {
    x = 64,
    y = 52,
    c = 7,
    s = 2,
    w = 24,
    spr = 2,
    timer = 1,
    dir = "r",
    update = function(self) 
      self.timer = self.timer + 1
      if self.timer >= 3 then
        self.timer = 0
        self.spr = self.spr + 1
        if self.spr > 5 then
          self.spr = 2
        end
      end
    	if btn(➡️) then
        self.dir = "r"
    	end
    	if btn(⬅️) then
        self.dir = "l"
    	end
      if btnp(❎) then
        
      end
      
      if self.dir == "r" then
        self.x += self.s
        self.x = min(self.x, 127-self.w)
      else
        self.x -= self.s
        self.x = max(self.x, 0)
      end
    end,

    draw = function(self)
      print(self.dir .. " ".. self.x, 10, 10)
      local flip = false
      if self.dir == "l" then
        flip = true
      end
      -- spr(self.spr, self.x, self.y, 1.0,1.0, flip)
      sspr(self.spr*8,0, 8,8, self.x,self.y, self.w,self.w, flip)
      -- pset(self.x, self.y, self.c)
    end,
  }
  
end

function _update()
  player:update()
end

function _draw()
  cls()
  rectfill(10,32, 117,64, 12)
  line(10,66, 117,66, 15)
  line(8,71, 119,71, 15)
  line(6,80, 121,80, 15)
  -- line(4,95, 123,95, 15)
  player:draw()
end
__gfx__
00000000000000000044440000444400000000000044440000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004444000046660000466600004444000046660000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700004666000065650000656500004666000065650000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006565000066660000666600006565000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000066660000dddd0000dddd000066660000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000ddddd000dddd0000dddd0000dddd0000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd00000dd00000d00d0000dddd0000d00d0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d00000dd00000d000000d0000d00d000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000
