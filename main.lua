
local billiardobj = billiardTable.new()
print("table" , billiardobj)
print ("table.world " ,billiardobj.physicsWorldOfbilliard)
stage:addChild(billiardobj)

local ball = cueBallProjection.new(billiardobj.physicsWorldOfbilliard)
stage:addChild(ball)

