

require "box2d"
billiardTable = Core.class(Sprite)

	
function billiardTable:init()
	self.table = Bitmap.new(Texture.new("img/billiard_table.png"))
	self:addChild(self.table)            -- adds the table object to instance of billiardTable 
	--[[Lets create the physics properties of table like cusion for rebounding and pockets to hold the ball ]]
	--lets create a physics world of billiard game
	self.physicsWorldOfbilliard = b2.World.new(0, 0, true)
	
	local tableWidth,tableHeight,railWidth,railHeight 
	tableWidth =self.table:getWidth()
	tableHeight = self.table:getHeight()
	railHeight  = 63   -- minimum height and width of the rail
	railWidth  = 63
	print("Width and height of the table" , tableWidth , tableHeight)
	--lets create table rails or cusion to stop the ball going off the table and for rebounding
	local toprail = self:interactiveRails(100,63,0 , 458)
	local toprailR = self:interactiveRails(638,63,0,470)
	local bottomrail = self:interactiveRails(542,621,3.1415 ,455)
	local bottomrail = self:interactiveRails(1094 , 621 , 3.1415 , 470 )
	local footrail = self:interactiveRails(71,581,-1.5707,488)
	local headrail = self:interactiveRails(1123 , 104 , 1.5707 ,486 )
	
	
	-- also make the pocket of the table active in physics world
	self:createpockets (55,55)
	self:createpockets(592 , 55)
	self:createpockets(1143 , 55)
	self:createpockets(55,628)
	self:createpockets(590,628)
	self:createpockets(1143,631)
	print("Printing Corner Pockets valuse " , cornerPockets)
	
	--just for reference, debug draw is very useful, to see the things happening in physics world
	local debugDraw = b2.DebugDraw.new()
	self.physicsWorldOfbilliard:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	

end



function billiardTable : interactiveRails(x,y,angle,maxi)
	local minimum = maxi-15
	local emptyRailbody = self.physicsWorldOfbilliard :createBody{type = b2.STATIC_BODY}
	emptyRailbody:setPosition(x,y)
	emptyRailbody:setAngle(angle)
	
	local railShape = b2.PolygonShape.new()
	railShape:set(-15,-28, maxi,-28,minimum,0, 0,0)       --- -10,-20, 465,-20,455,0, 0,0

	-- let give shape to the rail body and define other properties of the rail
	local railFixture = emptyRailbody:createFixture{shape = railShape ,density = 1, friction = 1, restitution = 0.1 }
	--railFixture:setFilterData({categoryBits = 1 , maskbits = 3, groupIndex = -1})
	--rail.body = body
	local reactiveRail = emptyRailbody
	return reactiveRail
end


function billiardTable:createpockets(x,y)
	self.body = self.physicsWorldOfbilliard:createBody{type = b2.STATIC_BODY }
	local circle = b2.CircleShape.new(x, y, 38)
	local fixture = self.body:createFixture{shape = circle, density = 500.0, 
	friction = 1, restitution = 0.8}
	fixture:setFilterData({categoryBits = 1 , maskbits = 1, groupIndex = -1})
	return body
end
