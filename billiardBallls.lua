billiardBalls = Core.class (Sprite)

BALLS_MASK = 1
REFERENCE_BALLMASK = 2
WALLS_MASK = 4
REFERENCE_WALLSMASK = 6

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


function billiardBalls:onEnterFrame()
	
	world:step(1/60, 8,3)
	local zeroVelocity =1
	
	--print("NUmber of child on Enterrrrrrrrrrrrr" , self:getNumChildren())
	for i = self:getNumChildren() , 1,-1  do
		--get specific sprite
		local sprite = self:getChildAt(i)
		--print("SSSSSSpppppprrrrrriiiiittttttteeeee" , sprite.body)
		-- check if sprite HAS a body (ie, physical object reference we added)
		if sprite.body  then
			--update position to match box2d world object's position
			--get physical body reference
			local body = sprite.body
			--get body coordinates
			local bodyX, bodyY = body:getPosition()
			if body:getLinearVelocity() == 0 and body.name == "ball" then
				zeroVelocity = zeroVelocity + 1
			--print("Velocity of the boby" , body.name , body:getLinearVelocity())
				if(zeroVelocity == self:getNumChildren())then
				--print("All the child at zero velocity")
				self.projectionObj:addEventListener(Event.MOUSE_DOWN , self.projectionObj.onMouseDown , self.projectionObj)
				self.projectionObj:addEventListener(Event.MOUSE_MOVE, self.projectionObj.onMouseMove,self.projectionObj)
				self.projectionObj:addEventListener(Event.MOUSE_UP, self.projectionObj.onMouseUp, self.projectionObj)
				end
			end
			--apply coordinates to sprite
			sprite:setPosition(bodyX, bodyY)
			if(sprite.body.delete)then
			--print("YAAAAAAAAAYYYYYYYYYYYYYYYYYYYYYYYYY" , sprite .body.name)
				world:destroyBody(body)
				sprite.body.delete = false
				--sprite.body =false
				--print("NUmber of child " , self:getNumChildren())
				--print("IIIIIIIIIIIIIIIIIIIIIII" , i)
				self:removeChild(sprite)
				--sprite.body = nil
				--sprite:removeChildAt(i)
				--sprite.body.delete = false
			
			end
			--apply rotation to sprite
			--sprite:setRotation(body:getAngle() * 180 / math.pi)
		end
	end
	
	
end

