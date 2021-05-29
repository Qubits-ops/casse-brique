io.stdout:setvbuf('no')

if arg[#arg] == "-debug" then require("mobdebug").start() end

local pad = {}
pad.x = 0
pad.y = 0
pad.largeur = 80
pad.hauteur = 20

local balle = {}
balle.x = 1
balle.y = 1
balle.rayon = 10
balle.colle = false
balle.vx = 0
balle.vy = 0

local brique = {}
local niveau = {}

function Demarre()
  balle.colle = true
  
  niveau = {}
  local l,c
  
  for l=1,6 do
    niveau[l] = {}
    for c=1,15 do
      niveau[l][c] = 1
    end
  end
end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  brique.hauteur = 25
  brique.largeur = largeur / 15
  
  pad.y = hauteur - (pad.hauteur/2)
  Demarre()
  
end

function love.update(dt)
  pad.x = love.mouse.getX()
  
  if balle.colle == true then
    balle.y = pad.y - balle.rayon*2
    balle.x = pad.x
    
  else
    balle.x = balle.x + (balle.vx * dt)
    balle.y = balle.y + (balle.vy * dt)
  end
  
  local c = math.floor(balle.x / brique.largeur) + 1
  local l = math.floor(balle.y / brique.hauteur) + 1
  if l > 0 and l <= #niveau and c >= 1 and c <= 15 then
    if niveau[l][c] == 1 then
      balle.vy = balle.vy * -1
      niveau[l][c] = 0
    end
  end
  
  if balle.x > largeur then
    balle.vx = balle.vx * -1
    balle.x = largeur
  end
  if balle.x < 0 then 
    balle.vx = balle.vx * -1
    balle.x = 0
  end
  if balle.y < 0 then
    balle.vy = balle.vy * -1
    balle.y = 0
  end
  if balle.y > hauteur then
    Demarre()
  end
  
  local posCollisionPad = pad.y - (pad.hauteur/2) - balle.rayon
  if balle.y > posCollisionPad then
    local dist = math.abs(pad.x - balle.x)
    if dist < pad.largeur/2 then
      balle.vy = balle.vy * -1
      balle.y = posCollisionPad
    end
  end
  
end

function love.draw()
  local l,c
  local bx,by = 0,0
  for l=1,6 do
    bx = 0
    for c=1,15 do
      if niveau[l][c] == 1 then
        love.graphics.rectangle("fill",bx + 1,by + 1,brique.largeur - 2,brique.hauteur - 2)
      end
      bx = bx + brique.largeur
    end
    by = by + brique.hauteur
  end
  love.graphics.rectangle("fill",pad.x - (pad.largeur/2),pad.y - (pad.hauteur/2),pad.largeur,pad.hauteur)
  love.graphics.circle("fill",balle.x,balle.y,balle.rayon)
end

function love.mousepressed(x,y,n)
  if balle.colle == true then
    balle.colle = false
    balle.vx = 200
    balle.vy = -200
  end
end

function love.keypressed(key)
  print(key)
end