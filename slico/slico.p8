pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

local player

function _init()
  player = {
    x = 64,
    y = 64,
    c = 7,
    s = 3,
    spr = 2,
    timer = 1,
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
      end
    end,

    draw = function(self)
      spr(self.spr, self.x, self.y)
      -- pset(self.x, self.y, self.c)
    end,
  }
  
end

function _update()
  player:update()
end

function _draw()
  cls()
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
