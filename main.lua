
local billiardobj = billiardTable.new()
print("table" , billiardobj)
print ("table.world " ,billiardobj.world)
stage:addChild(billiardobj)

local ball = cueBallProjection.new(billiardobj.world)
stage:addChild(ball)

