require "box2d"
billiardTable = Core.class(Sprite)

	
function billiardTable:init()
	self.table = Bitmap.new(Texture.new("img/billiard_table.png"))
	self:addChild(self.table)            -- adds the table object to instance of billiardTable 
	
	--lets create a physics world of billiard game
	self.physicsWorldOfbilliard = b2.World.new(0, 0, true)
	
	local tableWidth,tableHeight,railWidth,railHeight
	tableWidth =self.table:getWidth()
	tableHeight = self.table:getHeight()
	railHeight  = 50   -- minimum height and width of the rail
	railWidth  = 50
	
	--lets create table rails to stop the ball going off the table.
	--rail(x,y,width,height) for reference
	local footrail = self:rail(50,tableHeight/2,railWidth,686)
	local toprail = self:rail(tableWidth/2 , 50 , 1200 , railHeight)
	local bottomrail = self:rail(tableWidth/2, 636 , 1200, railHeight )
	local headrail  = self:rail(1150, tableHeight/2 , railWidth,686)  
	
	--To give the physics property to rails such as collision detection we need to 
	--create box2d identity of the above created rails and stage it 
	self:addChild(self:interactiveRails(footrail))
	self:addChild(self:interactiveRails(toprail))
	self:addChild(self:interactiveRails(bottomrail))
	self:addChild(self:interactiveRails(headrail))
	
	--just for reference, debug draw is very useful, to see the things happening in physics world
	local debugDraw = b2.DebugDraw.new()
	self.physicsWorldOfbilliard:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	

end

function billiardTable:rail(x,y,width, height )
	print("widht : ",width ," height : ",height , " x : " , x , "y : " , y)
	--shape of the rail is rectangle
	local railshape = Shape.new()
	--print("shape AnchorPoint : " , shape:getAnchorPoint())
	
	railshape:setLineStyle(5, 0xff0000, 1)
	railshape:beginPath()
	railshape:moveTo(-width/2, -height/2)   --shape : moveTo()
	railshape:lineTo(width/2,-height/2)
	railshape:lineTo(width/2, height/2)
	railshape:lineTo(-width/2,height/2)
	railshape:closePath()
	railshape:endPath()
	railshape:setPosition(x,y)
	print("X and Y position of railshape " , railshape:getPosition())
	
	return railshape
end

function billiardTable : interactiveRails(rail)
	
	local railProperty = self.physicsWorldOfbilliard:createBody{type = b2.STATIC_BODY}
	railProperty:setPosition(rail:getX(),rail:getY())
	
	local railShape = b2.PolygonShape.new()
	railShape:setAsBox(rail:getWidth()/2 , rail :getHeight()/2)

	local attachRailshapetobody = railProperty:createFixture{shape = railShape ,density = 1, friction = 1, restitution = 0.1 }
	
	rail.body = body
	
	return rail

end


function billiardTable:loophole(x,y)
	local body = self.physicsWorldOfbilliard:createBody{type = b2.STATIC_BODY }
	local circle = b2.CircleShape.new(x, y, 38)
	local fixture = body:createFixture{shape = circle, density = 500.0, 
	friction = 1, restitution = 0.8}

end
