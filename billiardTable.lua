require "box2d"
billiardTable = Core.class(Sprite)
--[[ Using this class one will be able to add the objects to the game(no functions and events are yet attached to the objects )
]]--

--local world = b2.World.new(0, 10, true)
function billiardTable:init()
	self.world = b2.World.new(0, 10, true)
	self:boundary()
	--wall(x,y,width,height)
	local height, width
	width = 50 -- depending on horizontal rectangle or vertical rectangle thickness will be same o.e 50
	height = width
	print("height and width " , height , width)
	self:wall(50,686/2,50,686)-- left vertical side
	self:wall(1200/2 , 50 , 1200 , height) -- top horizontal side
	self:wall(1200/2, 636 , 1200, height ) -- bottom horizontal side
	self:wall(1150, 686/2 , width,686)  -- right vertical side
	self:loophole(60,55)
	self:loophole(590,55)
	self:loophole(1145,55)
	self:balls()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame)
	self:addChild(cueBallProjection.new())
	--just for reference, debug draw is very useful, to see the things happening in physics world
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
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
function billiardTable:balls()
	local cueBall = Bitmap.new(Texture.new("img/cueball.png"))
	cueBall:setAnchorPoint(0.5,0.5)
	local projectBall = Bitmap.new(Texture.new("img/projectedCueBall.png"))
	projectBall:setAnchorPoint(0.5,0.5)
	cueBall:setPosition(100,100)
	projectBall:setPosition(300, 300)
	
	--let create physics property of this ball
	local function ballPhysics(ball)
	local body = self.world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(ball:getX(),ball:getY())
	local circle = b2.CircleShape.new(0,0,25)
	local fixture = body:createFixture{shape = circle, density = 500.0, 
	friction = 1, restitution = 0.8}
	ball.body = body
	end
	ballPhysics(cueBall)
	ballPhysics(projectBall)
	self:addChild(cueBall)
	self:addChild(projectBall)
	--return cueball , projectBall
	
 end
 function billiardTable:onEnterFrame()
 self.world:step(1/60, 1,3)
 end