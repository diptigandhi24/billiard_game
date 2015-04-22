billiardBalls = Core.class (Sprite)

function billiardBalls : init()

	self.cueBall = Bitmap.new(Texture.new("img/cueball.png"))
	self.cueBall:setAnchorPoint(0.5,0.5)
	self.cueBall:setPosition( 400 , 400)
	self:physicsPropertyOfBall(self.cueBall,world)
	self:addChild(self.cueBall)
	self.name = "cueBall"

--Arrangement of the coloredBalls
	self.coloredBalls = Bitmap.new(Texture.new("img/colouredBall.png"))
	self.coloredBalls:setAnchorPoint(0.5,0.5)
	self.coloredBalls:setPosition(800,400)
	self:physicsPropertyOfBall(self.coloredBalls ,world)
	self:addChild(self.coloredBalls)
	self.name = "coloredBalls"
	
	self.coloredBalls2 = Bitmap.new(Texture.new("img/colouredBall.png"))
	self.coloredBalls2:setAnchorPoint(0.5,0.5)
	self.coloredBalls2:setPosition(1000,500)
	self:physicsPropertyOfBall(self.coloredBalls2 ,world)
	self:addChild(self.coloredBalls2)
	
--create the projection of cueball and detect the collision in the path
	self.projectionObj = cueBallProjection.new( world, self.cueBall)
	self:addChild(self.projectionObj)
	

-- update the position of ball every frame
	self:addEventListener(Event.ENTER_FRAME, function()
	world:step(1/60, 8,3)
	local zeroVelocity =1
	for i = 1, self:getNumChildren() do
		--get specific sprite
		local sprite = self:getChildAt(i)
		-- check if sprite HAS a body (ie, physical object reference we added)
		if sprite.body then
			--update position to match box2d world object's position
			--get physical body reference
			local body = sprite.body
			--get body coordinates
			local bodyX, bodyY = body:getPosition()
			if body:getLinearVelocity() == 0 and body.name == "ball" then
				zeroVelocity = zeroVelocity + 1
			--print("Velocity of the boby" , body.name , body:getLinearVelocity())
			if(zeroVelocity == self:getNumChildren())then
				self.projectionObj:addEventListener(Event.MOUSE_DOWN , self.projectionObj.onMouseDown , self.projectionObj)
				self.projectionObj:addEventListener(Event.MOUSE_MOVE, self.projectionObj.onMouseMove,self.projectionObj)
				self.projectionObj:addEventListener(Event.MOUSE_UP, self.projectionObj.onMouseUp, self.projectionObj)
			end
			
			
			end
			--apply coordinates to sprite
			sprite:setPosition(bodyX, bodyY)
			--apply rotation to sprite
			--sprite:setRotation(body:getAngle() * 180 / math.pi)
		end
	end
	end)
	
end

function billiardBalls:physicsPropertyOfBall(ball,world  )
 
	local body = world:createBody{type = b2.DYNAMIC_BODY}
	body.name = "ball"
	body:setPosition(ball:getX(),ball:getY())
	body:setLinearDamping(0.5)
	body:setAngularDamping(1)
	
	local innerCircle = b2.CircleShape.new(0,0,20)
	local innerFixture = body:createFixture{shape = innerCircle, density = 1, 
	friction = 1, restitution = 0.8}
	innerFixture:setFilterData{categoryBits = 1, maskBits = 1  }
	
	
	local outerCircle = b2.CircleShape.new(0,0,40)
	local outerfixture = body:createFixture{shape = outerCircle, density = 1, 
	friction = 1, restitution = 0.8 }
	outerfixture:setFilterData{categoryBits = 2, maskBits = 1 , groupIndex = -3}
	
	--ball.body = body
	--ball.fixture = fixture
	
	ball.body = body
	
	ball.fixture = outerfixture

end

--[[function billiardBalls:onEnterFrame(world)
	world:step(1/60, 8,3)
	
	for i = 1, self:getNumChildren() do
		--get specific sprite
		local sprite = self:getChildAt(i)
		-- check if sprite HAS a body (ie, physical object reference we added)
		if sprite.body then
			--update position to match box2d world object's position
			--get physical body reference
			local body = sprite.body
			--get body coordinates
			local bodyX, bodyY = body:getPosition()
			--apply coordinates to sprite
			sprite:setPosition(bodyX, bodyY)
			--apply rotation to sprite
			--sprite:setRotation(body:getAngle() * 180 / math.pi)
		end
	end

 end]]--