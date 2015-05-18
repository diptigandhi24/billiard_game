--Remember you cannot delete and add ball body anywhere in the game , it is handle by OnEnterFrame function

billiardBalls = Core.class (Sprite)

BALLS_MASK = 1
REFERENCE_BALLMASK = 2
WALLS_MASK = 4
REFERENCE_WALLSMASK = 8
PreView_Mask = 16

function billiardBalls : init(BitmapOfTable)

	local X_INTIAL_CUEBALLPOSITION = 400
	local Y_INTIAL_CUEBALLPOSITION = 400
	
	self:addCueball(X_INTIAL_CUEBALLPOSITION ,Y_INTIAL_CUEBALLPOSITION)

	--Arrangement of the coloredBalls
	--Balls are self because they are added to the stage in the main class
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
	
	--create the projection of cueball and add it to the stage 
	
	self.projectionObj = cueBallProjection.new( world, self.cueBall , BitmapOfTable)
	self:addChild(self.projectionObj)
	

-- update the position of ball every frame
	--When any ball comes in contact with  pockets  , delete the ball
	
	world:addEventListener(Event.BEGIN_CONTACT, self.onContact ,self )
	world:addEventListener(Event.END_CONTACT , self.endContact ,self)
	
	-- update the position  of ball every frame
	--Also you can add and remove the ball only in onEnterFrame function , as world update itself in it.
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame , self)
	
	-- The two images added below are invisble when the screen is loaded .They are made visible and are used only when the cueball falls in the pocket. 
	--------- If the cueball ball is deleted reload the ball to user selected place------------
	-- show the preview of cueball position 
	self.cueballPositionPreview = Bitmap.new(Texture.new("img/reloadCueball.png"))
	self.cueballPositionPreview:setPosition(X_INTIAL_CUEBALLPOSITION ,Y_INTIAL_CUEBALLPOSITION)
	self.cueballPositionPreview:setAnchorPoint(0.5 , 0.5)
	self:addChild(self.cueballPositionPreview)
	self.cueballPositionPreview:setVisible(false)
	
	--if the user selected place is not correct then show Noentry image
	
	self.cueballNotPlaceableIndicator = Bitmap.new(Texture.new("img/noentry.png"))
	self.cueballNotPlaceableIndicator:setAnchorPoint(0.5,0.5)
	self.cueballNotPlaceableIndicator:setPosition(X_INTIAL_CUEBALLPOSITION ,Y_INTIAL_CUEBALLPOSITION)
	self:addChild(self.cueballNotPlaceableIndicator)
	self.cueballNotPlaceableIndicator:setVisible(false)
	
	
	print("The number of child billiard balls has in the beginning " , self:getNumChildren())
	
end

function billiardBalls:physicsPropertyOfBall(ball)
 
	local body = world:createBody{type = b2.DYNAMIC_BODY}
	body.name = "ball"
	body:setPosition(ball:getX(),ball:getY())
	body:setLinearDamping(0.5)
	body:setAngularDamping(1)
	
	local innerCircle = b2.CircleShape.new(0,0,20)
	local innerFixture = body:createFixture{shape = innerCircle, density = 1, friction = 1, restitution = 0.8  }
	--All the balls will collide with other balls and walls
	innerFixture:setFilterData{categoryBits = BALLS_MASK, maskBits = BALLS_MASK+WALLS_MASK + PreView_Mask    }
	
	--outerFixture doesnt collide with any fixture
	local outerCircle = b2.CircleShape.new(0,0,40)
	local outerfixture = body:createFixture{shape = outerCircle, density = 1, friction = 1, restitution = 0.8 }
	outerfixture:setFilterData{ categoryBits = REFERENCE_BALLMASK , maskBits = 1 , groupIndex = -3 }
	
	ball.body = body
	ball.fixture = innerFixture
	

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
		if(bodyA.name == "reload" and bodyB.name =="ball")then
			self.cueballNotPlaceableIndicator:setVisible(true)
		end

end
function billiardBalls:endContact(e)
		print("Contact End ")
		local fixtureA = e.fixtureA
		
		local fixtureB = e.fixtureB
		
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB :getBody()
		
		if(bodyA.name == "reload" and bodyB.name =="ball")then
			self.cueballNotPlaceableIndicator:setVisible(false)
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
				self:removeChild(sprite)
			
				
				if sprite.name == "cueBall"  then	--if the deleted ball is cueball 
					self.reloadobj = ReloadThecueBall.new(self.cueballPositionPreview ,self.cueballNotPlaceableIndicator )
					self:addChild(self.reloadobj)
					
				end
				
				if sprite.body.name =="reload" then
					self:addCueball(self.reloadobj.SetX , self.reloadobj.SetY )
					self:removeChild(self.reloadobj)
					
				end
				
			end
			--if cueball gets deleted from the game then add it again 
			
			
			
			
		end
	end
	
	
end

