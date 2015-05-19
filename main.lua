--not going to add  billiardstick

require "box2d"
--lets create an interactive world , where all the objects/actors of the game will be added

world = b2.World.new(0, 0, true) --global world

local createTable = billiardTable.new()
stage:addChild(createTable)

local createball = billiardBalls.new(createTable.table)
stage:addChild(createball)








