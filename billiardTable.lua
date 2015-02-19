require "box2d"
billiardTable = Core.class(Sprite)
--[[ The main purpose of this class create billiard table with physics properties and make the physics world avaiable for 
		other object to get added in it. 
]]--

	--local world = b2.World.new(0, 10, true) -- we need only one world object so its local
function billiardTable:init()
	self.world = b2.World.new(0, 0, true)
	self.table = Bitmap.new(Texture.new("img/billiard_table.png"))
	--[[WHY I M ADDING BITMAP OBJECT TABLE TO THE INSTANCE OF BILLIARDTABLE class ?
	because with Bitmap.new you are just storing the object in the self.table variable
	so even though instance has table property in it , but instance does not know what to do with it
	]]--
		
	self:addChild(self.table)            -- adds the table object to instance of billiardTable 
	local tableWidth,tableHeight,wallWidth,wallHeight
	tableWidth =self.table:getWidth()
	tableHeight = self.table:getHeight()
	wallHeight  = 50
	wallWidth  =50
	--wall(x,y,width,height) for reference
	self:wall(50,tableHeight/2,wallWidth,686)-- left  side of the wall kept at the centre of tableheight
	self:wall(tableWidth/2 , 50 , 1200 , wallHeight) -- top horizontal side
	self:wall(tableWidth/2, 636 , 1200, wallHeight ) -- bottom horizontal side
	self:wall(1150, tableHeight/2 , wallWidth,686)  -- right vertical side
	--loophole doesnt look neat
	self:loophole(60,55)  -- change name to pockets
	self:loophole(590,55)
	self:loophole(1145,55)
	--just for reference, debug draw is very useful, to see the things happening in physics world
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	

end

function billiardTable:wall(x,y,width, height )
	print("widht : ",width ," height : ",height , " x : " , x , "y : " , y)
	local shape = Shape.new()
	--print("shape AnchorPoint : " , shape:getAnchorPoint())
	shape:setLineStyle(5, 0xff0000, 1)
	shape:beginPath()
	shape:moveTo(-width/2, -height/2)   --shape : moveTo()
	shape:lineTo(width/2,-height/2)
	shape:lineTo(width/2, height/2)
	shape:lineTo(-width/2,height/2)
	shape:closePath()
	shape:endPath()
	shape:setPosition(x,y)
	print("X and Y position of shape " , shape:getPosition())
	-- add physics properties to the wall
	local body = self.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(shape:getX(),shape:getY())
	local poly = b2.PolygonShape.new()
	poly:setAsBox(shape:getWidth()/2 , shape:getHeight()/2)
	local fixture = body:createFixture{shape = poly, density = 500.0, 
	friction = 1, restitution = 0.8}
	shape.body = body
	self:addChild(shape)
end


function billiardTable:loophole(x,y)
	local body = self.world:createBody{type = b2.STATIC_BODY }
	local circle = b2.CircleShape.new(x, y, 38)
	local fixture = body:createFixture{shape = circle, density = 500.0, 
	friction = 1, restitution = 0.8}

end
