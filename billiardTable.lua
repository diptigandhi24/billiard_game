

require "box2d"
billiardTable = Core.class(Sprite)

	
function billiardTable:init()

	self.table = Bitmap.new(Texture.new("img/billiard_table.png"))
	self:addChild(self.table)            -- adds the table object to instance of billiardTable 
	
	
	--Lets create the physics properties of table like cusion for rebounding and pockets 
	--lets create a physics world of billiard game
	local tableWidth,tableHeight,railWidth,railHeight 
	tableWidth =self.table:getWidth()
	tableHeight = self.table:getHeight()
	railHeight   = 63   -- minimum height and width of the rail
	railWidth  = 63
	print("Width and height of the table" , tableWidth , tableHeight)
	
	--lets create table rails or cusion to stop the ball going off the table and for rebounding
	local toprailL = self:interactiveRails(100,63,0 , 458 ) --L for left side of the table
	local toprailR = self:interactiveRails(638,63,0,470)	--R for right side of the table
	local bottomrailL = self:interactiveRails(542,621,3.1415 ,455)
	local bottomrailR = self:interactiveRails(1094 , 621 , 3.1415 , 470)
	local footrail = self:interactiveRails(71,581,-1.5707,488) --left
	local headrail = self:interactiveRails(1123 , 104 , 1.5707 ,486 ) -- right
	
	-- lets create the pockets in physics world 
	self:createpockets (55,55)
	self:createpockets(592 , 55)
	self:createpockets(1143 , 55)
	self:createpockets(55,628)
	self:createpockets(590,628)
	self:createpockets(1143,631)
	print("Printing Corner Pockets valuse " , cornerPockets)
	
	--just for reference, debug draw is very useful, to see the things happening in physics world
	local debugDraw = b2.DebugDraw.new()
	world:setDebugDraw(debugDraw)
	--self:addChild(debugDraw)
	
	
end



function billiardTable : interactiveRails(x,y,angle,longestSide)

	local minimum = longestSide-15		--longest side can verticle or horzontal depending on the respective verticle and horizontal rails
	local body = world :createBody{type = b2.STATIC_BODY}
			body.name = "rail"
			body:setPosition(x,y)	--this is the first point of polygon refer as (0,0)
			body:setAngle(angle)
	
	local polyshape = b2.PolygonShape.new() --all the polygons are drawn in clockwise direction.
				-- start drawing lines from  0,0
				--first pt 0,0, second pt ,	 third pt        ,  fourth pt   , bck to firstpoint
				polyshape:set(  -15,-28   ,  longestSide,-28 ,  minimum,0   ,    0,0      ) 
	
	
	-- let give shape to the rail body and define other properties of the rail
	local fixture= body:createFixture{shape = polyshape ,density = 1, friction = 1, restitution = 0.1 }
			
			--fixture:setFilterData{categoryBits = 4, maskBits = 1 , groupIndex = -3}
			--Inner walls collide with all the balls
			fixture:setFilterData{categoryBits = WALLS_MASK, maskBits = BALLS_MASK  , groupIndex = -3}
	
	
end

function billiardTable:createpockets(x,y)
	local body = world:createBody{type = b2.STATIC_BODY }
	--body:setAnchorPoint(0.5 , 0.5)
	body.name = "Pockets"
	
	local innerCircle = b2.CircleShape.new(x, y, 38)
	local innerFixture = body:createFixture{shape = innerCircle, density = 500.0, 
						friction = 1, restitution = 0.8}
		  innerFixture:setFilterData{categoryBits = BALLS_MASK, maskBits = BALLS_MASK + PreView_Mask }
		  innerFixture:setSensor(true)
	
	local outerCircle = b2.CircleShape.new(x, y, 55)
	local outerFixture = body:createFixture{shape = outerCircle, density = 500.0, 
						friction = 1, restitution = 0.8}
		  outerFixture:setFilterData{categoryBits = REFERENCE_BALLSMASK, maskBits = BALLS_MASK , groupIndex = -3} 
	
	
	--return body
end



