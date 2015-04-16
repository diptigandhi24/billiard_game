--not going to add  billiardstick
require "box2d"
--lets create an interactive world , where all the objects/actors of the game will be added
world = b2.World.new(0, 0, true)

local createTable = billiardTable.new(world)
stage:addChild(createTable)

local createball = billiardBalls.new(world)
stage:addChild(createball)
--cueball projection will be created in createball class
--onEnterFrame will be created in billiardBalls class
--cueballprojection function will be added in createBalls class






world:addEventListener(Event.BEGIN_CONTACT , function(e)
		print("contact Begins")
		local fixtureA = e.fixtureA
		local fixtureB = e.fixtureB
		
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB :getBody()
		
		print("begin contact: "..bodyA.name.."<->"..bodyB.name)
		if(bodyA.name =="Pockets" and bodyB.name == "ball")then
			print("delete ballllllll")
			--world:destroyBody(bodyB)
			--createball:removeChild(createball.cueBall)
			
			
		end
	end)

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
