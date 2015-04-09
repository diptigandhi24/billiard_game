billiardBalls = Core.class (Sprite)

function billiardBalls : init(physicsWorldOfbilliard)

	self.addsBallsToPhysicsWorld = physicsWorldOfbilliard
	self.cueBall = Bitmap.new(Texture.new("img/cueball.png"))
	self.cueBall:setAnchorPoint(0.5,0.5)
	self.cueBall:setPosition( 400 , 400)
	self:physicsPropertyOfBall(self.cueBall)
	self:addChild(self.cueBall)

--Arrangement of the coloredBalls
	self.coloredBalls = Bitmap.new(Texture.new("img/colouredBall.png"))
	self.coloredBalls:setAnchorPoint(0.5,0.5)
	self.coloredBalls:setPosition(1000,600)
	self:physicsPropertyOfBall(self.coloredBalls)
	self:addChild(self.coloredBalls)
	
--create the projection of cueball and detect the collision in the path
	self:addChild(cueBallProjection.new( self.addsBallsToPhysicsWorld , self.cueBall))
	

-- update the position of ball every frame
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
end

function billiardBalls:physicsPropertyOfBall(ball  )
 
	local body = self.addsBallsToPhysicsWorld:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(ball:getX(),ball:getY())
	
	local innerCircle = b2.CircleShape.new(0,0,18)
	local innerFixture = body:createFixture{shape = innerCircle, density = 0, 
	friction = 1, restitution = 0.8}
	innerFixture:setFilterData{categoryBits = 1, maskBits = 1  }
	
	
	local outerCircle = b2.CircleShape.new(0,0,45)
	local outerfixture = body:createFixture{shape = outerCircle, density = 0, 
	friction = 1, restitution = 0.8 }
	outerfixture:setFilterData{categoryBits = 2, maskBits = 1 , groupIndex = -3}
	
	--ball.body = body
	--ball.fixture = fixture
	ball.body = body
	ball.fixture = outerfixture

end

function billiardBalls:onEnterFrame()
	self.addsBallsToPhysicsWorld:step(1/60, 8,3)
	
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

 end