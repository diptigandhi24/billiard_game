require "box2d"
billiardTable = Core.class(Sprite)
--[[ Using this class one will be able to add the objects to the game(no functions and events are yet attached to the objects )
]]--

local world = b2.World.new(0, 0, true)
function billiardTable:init()
self:boundary()
--wall(x,y,width,height)
self:wall(0,686/2,150,686)
self:wall(1200/2 , 0 , 1200 , 130)
self:wall(1200/2, 686 , 1200, 130 )
self:wall(1200, 686/2 , 130,686)
self:loophole()
	local debugDraw = b2.DebugDraw.new()
	world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)

end

function billiardTable:boundary() 
	self.table = Bitmap.new(Texture.new("img/billiard_table.png"))
	print("X , Y position of the image " , self.table:getPosition())
	--WHY I M ADDING BITMAP OBJECT TABLE TO THE INSTANCE OF BILLIARDTABLE class ?
	-- because with Bitmap.new you are just storing the object in the self.table variable
	-- so even though instance has table property in it , but instance does not know what to do with it
		
	self:addChild(self.table)            -- add the table object to instance of billiardTable 
	local width = self.table:getWidth()
	local height = self.table:getHeight()
	print("width : ", width)
	print("height : ", height)
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
	self:addChild(shape)
end


function billiardTable:loophole()
	local body = world:createBody{type = b2.STATIC_BODY }
	--body:setAnchorPoint(1,1)
	local circle = b2.CircleShape.new(50, 50, 50)
	local fixture = body:createFixture{shape = circle, density = 500.0, 
	friction = 1, restitution = 0.8}

end