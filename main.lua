--not going to add  billiardstick
require "box2d"
--lets create an interactive world , where all the objects/actors of the game will be added

world = b2.World.new(0, 0, true) --global world

local createTable = billiardTable.new()
stage:addChild(createTable)

local createball = billiardBalls.new(createTable.table)
stage:addChild(createball)
--print("Child of Billiard balls " , parentSprite:getNumChildren())
--cueball projection will be created in createball class
--onEnterFrame will be created in billiardBalls class
--cueballprojection function will be added in createBalls class







--[[for i=1 ,15 do

	local forcestrip = Shape.new()
	forcestrip:setLineStyle(2 ,0xff0000 )
	forcestrip:beginPath()
	forcestrip:moveTo(x , y)
	forcestrip:lineTo(x+50 ,y)
	forcestrip:lineTo(x+50 ,y+10)
	forcestrip:lineTo(x ,y+10)
	forcestrip:closePath()
	forcestrip:endPath()

	y = y+15
	stage:addChild(forcestrip)
end
]]--
