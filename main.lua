--not going to add  billiardstick
local billiardobj = billiardTable.new()
print("table" , billiardobj)
print ("table.world " ,billiardobj.physicsWorldOfbilliard)
stage:addChild(billiardobj)

local ball = cueBallProjection.new(billiardobj.physicsWorldOfbilliard)
stage:addChild(ball)

local x = 1220  y = 100
for i=1 ,15 do

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
