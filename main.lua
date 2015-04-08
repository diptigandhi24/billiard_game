--not going to add  billiardstick
require "box2d"
--lets create an interactive world , where all the objects/actors of the game will be added
local physicsWorldOfbilliard = b2.World.new(0, 0, true)

local createTable = billiardTable.new(physicsWorldOfbilliard)
stage:addChild(createTable)

local createball = billiardBalls.new(physicsWorldOfbilliard)
stage:addChild(createball)
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
