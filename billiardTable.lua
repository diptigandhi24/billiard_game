

require "box2d"
billiardTable = Core.class(Sprite)

	
function billiardTable:init(world)

	self.table = Bitmap.new(Texture.new("img/billiard_table.png"))
	self:addChild(self.table)            -- adds the table object to instance of billiardTable 
	--[[Lets create the physics properties of table like cusion for rebounding and pockets to hold the ball ]]
	--lets create a physics world of billiard game
	
	local tableWidth,tableHeight,railWidth,railHeight 
	tableWidth =self.table:getWidth()
	tableHeight = self.table:getHeight()
	railHeight  = 63   -- minimum height and width of the rail
	railWidth  = 63
	print("Width and height of the table" , tableWidth , tableHeight)
	--lets create table rails or cusion to stop the ball going off the table and for rebounding
	local toprail = self:interactiveRails(100,63,0 , 458 ,world)
	local toprailR = self:interactiveRails(638,63,0,470,world)
	local bottomrail = self:interactiveRails(542,621,3.1415 ,455,world)
	local bottomrail = self:interactiveRails(1094 , 621 , 3.1415 , 470 ,world)
	local footrail = self:interactiveRails(71,581,-1.5707,488,world)
	local headrail = self:interactiveRails(1123 , 104 , 1.5707 ,486 ,world)
	
	-- also make the pocket of the table active in physics world
	self:createpockets (55,55,world)
	self:createpockets(592 , 55,world)
	self:createpockets(1143 , 55,world)
	self:createpockets(55,628,world)
	self:createpockets(590,628,world)
	self:createpockets(1143,631,world)
	print("Printing Corner Pockets valuse " , cornerPockets)
	
	--just for reference, debug draw is very useful, to see the things happening in physics world
	local debugDraw = b2.DebugDraw.new()
	world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	
	
end



function billiardTable : interactiveRails(x,y,angle,longestSide,world)
	local minimum = longestSide-15
	local body = world :createBody{type = b2.STATIC_BODY}
	body.name = "rail"
--this is the first point of polygon refer as (0,0)
	body:setPosition(x,y)
	body:setAngle(angle)
--all the polygons are drawn in clockwise direction.
	local polyshape = b2.PolygonShape.new()
	
-- start drawing lines from  0,0
--first pt 0,0	   second pt  ,third pt        ,fourth pt    ,bck to firstpoint
	polyshape:set( -15,-28,   longestSide,-28,  minimum,0,    0,0 ) 
	
	
	-- let give shape to the rail body and define other properties of the rail
	local fixture= body:createFixture{shape = polyshape ,density = 1, friction = 1, restitution = 0.1 }
	fixture:setFilterData{categoryBits = 1, maskBits = 1 , groupIndex = -3}
	
	
end

function billiardTable:createpockets(x,y,world)
	local body = world:createBody{type = b2.STATIC_BODY }
	body.name = "Pockets"
	
	local innerCircle = b2.CircleShape.new(x, y, 38)
	local innerFixture = body:createFixture{shape = innerCircle, density = 500.0, 
	friction = 1, restitution = 0.8}
	innerFixture:setFilterData{categoryBits = 1, maskBits = 1  }
	innerFixture:setSensor(true)
	
	local outerCircle = b2.CircleShape.new(x, y, 55)
	local outerFixture = body:createFixture{shape = outerCircle, density = 500.0, 
	friction = 1, restitution = 0.8}
	outerFixture:setFilterData{categoryBits = 2, maskBits = 1 , groupIndex = -3} 
	
	
	--return body
end



