billiardBalls = Core.class (Sprite)

BALLS_MASK = 1
REFERENCE_BALLMASK = 2
WALLS_MASK = 4
REFERENCE_WALLSMASK = 6

function billiardBalls : init(BitmapOfTable)

	self:addCueball(400,400)

--Arrangement of the coloredBalls
	self.coloredBalls = Bitmap.new(Texture.new("img/colouredBall.png"))
	self.coloredBalls:setAnchorPoint(0.5,0.5)
	self.coloredBalls:setPosition(800,400)
	self:physicsPropertyOfBall(self.coloredBalls ,world)
	self:addChild(self.coloredBalls)
	self.coloredBalls.name = "coloredBalls"
	
	self.coloredBalls2 = Bitmap.new(Texture.new("img/colouredBall.png"))
	self.coloredBalls2:setAnchorPoint(0.5,0.5)
	self.coloredBalls2:setPosition(1000,500)
	self:physicsPropertyOfBall(self.coloredBalls2 ,world)
	self:addChild(self.coloredBalls2)
	self.coloredBalls2.name = "coloredBalls"
	
--create the projection of cueball and detect the collision in the path
	self.projectionObj = cueBallProjection.new( world, self.cueBall , BitmapOfTable)
	self:addChild(self.projectionObj)
	

-- update the position of ball every frame
	world:addEventListener(Event.BEGIN_CONTACT, self.onContact ,self )
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame , self)
end

function billiardBalls:physicsPropertyOfBall(ball
)
 
	local body = world:createBody{type = b2.DYNAMIC_BODY}
	body.name = "ball"
	body:setPosition(ball:getX(),ball:getY())
	body:setLinearDamping(0.5)
	body:setAngularDamping(1)
	
	local innerCircle = b2.CircleShape.new(0,0,20)
	local innerFixture = body:createFixture{shape = innerCircle, density = 1, friction = 1, restitution = 0.8}
	--All the balls will collide with other balls and walls
	innerFixture:setFilterData{categoryBits = BALLS_MASK, maskBits = BALLS_MASK+WALLS_MASK  }
	
	--outerFixture doesnt collide with any fixture
	local outerCircle = b2.CircleShape.new(0,0,40)
	local outerfixture = body:createFixture{shape = outerCircle, density = 1, friction = 1, restitution = 0.8 }
	outerfixture:setFilterData{categoryBits = REFERENCE_BALLMASK, maskBits = 1 , groupIndex = -3}
	
	--ball.body = body
	--ball.fixture = fixture
	
	ball.body = body
	
	--ball.fixture = outerfixture

end

function billiardBalls:onContact(e)
	local fixtureA = e.fixtureA
		
		local fixtureB = e.fixtureB
		
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB :getBody()
		
		print("begin contact: "..bodyA.name.."<->"..bodyB.name)
		if(bodyA.name =="Pockets" and bodyB.name == "ball")then
			--createball.deleteBody = true
			--bodyB:setRotation(2.12)
			bodyB.delete = true

			
		end

end

function billiardBalls:addCueball(x,y)
	self.cueBall = Bitmap.new(Texture.new("img/cueball.png"))
	self.cueBall:setAnchorPoint(0.5,0.5)
	self.cueBall:setPosition( x ,y)
	self:physicsPropertyOfBall(self.cueBall,world)
	self:addChild(self.cueBall)
	self.cueBall.name = "cueBall"

end

function billiardBalls:onEnterFrame()
	
	world:step(1/60, 8,3)
	local zeroVelocityObjects =1 -- because in lua counting of elements/indexes starts from 1 and not from zero. 
	
--  Reverse for loop in which last in first out (lifo) is applied 
--  for better explaination refer http://howto.oz-apps.com/2011/09/tower-of-babel-no-honoi-maybe.html
	for i = self:getNumChildren() , 1,-1  do
		--get specific sprite
		local sprite = self:getChildAt(i)
		
			-- check if sprite HAS a body (ie, physical object reference we added)
		if sprite.body  then
			--update position to match box2d world object's position
			--get physical body reference
			local body = sprite.body
			--get body coordinates
			local bodyX, bodyY = body:getPosition()
			
			if sprite.name == cueBall and sprite == nil then
				self:addCueball(400,400)
			end
			--If all the objects are at rest then unable the touch events in the game
			if body:getLinearVelocity() == 0 and body.name == "ball" then
				zeroVelocityObjects = zeroVelocityObjects + 1
				if(zeroVelocityObjects == self:getNumChildren())then
					
					self.projectionObj:addEventListener(Event.MOUSE_DOWN , self.projectionObj.onMouseDown , self.projectionObj)
					self.projectionObj:addEventListener(Event.MOUSE_MOVE, self.projectionObj.onMouseMove,self.projectionObj)
					self.projectionObj:addEventListener(Event.MOUSE_UP, self.projectionObj.onMouseUp, self.projectionObj)
					self.projectionObj.projectBall:setVisible(true)
					world:rayCast(self.projectionObj.cueBall:getX() ,self.projectionObj.cueBall:getY(),self.projectionObj.projectBall:getX(),self.projectionObj.projectBall:getY(), self.projectionObj.raycastCallback ,self.projectionObj)
				end
			end
			--apply coordinates to sprite
			sprite:setPosition(bodyX, bodyY)
			if(sprite.body.delete)then
				
				world:destroyBody(body)
				sprite.body.delete = false
				print("Sprite NAMEEEEEEEEEE" , sprite.name)
				
				self:removeChild(sprite)
				print("Sprite NAMEEEEEEEEEE" , sprite.name)
				--sprite = nil
				print("Sprite NAMEEEEEEEEEE" , sprite.name)
				if sprite.name == "cueBall"  then
				print("YEEEEPPPPPPPPP")
					self:addCueball(400,400)
				end
				print("Sprite NAMEEEEEEEEEE" , sprite.name)
				
			end
			--if cueball gets deleted from the game then add it again 
			
			
			
			
		end
	end
	
	
end

