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
	self:physicsPropertyOfBall(self.coloredBalls)
	self:addChild(self.coloredBalls)
	self.coloredBalls.name = "coloredBalls"
	
	self.coloredBalls2 = Bitmap.new(Texture.new("img/colouredBall.png"))
	self.coloredBalls2:setAnchorPoint(0.5,0.5)
	self.coloredBalls2:setPosition(1000,500)
	self:physicsPropertyOfBall(self.coloredBalls2)
	self:addChild(self.coloredBalls2)
	self.coloredBalls2.name = "coloredBalls"
	
	--creates the projection of cueball and add it to the billiard class.
	self.billiardTableObj = BitmapOfTable
	self.projectionObj = cueBallProjection.new( self.cueBall ,self.billiardTableObj )
	self:addChild( self.projectionObj )
	
	--when world bodies comes in contact with eachother perform the following events
	world:addEventListener( Event.BEGIN_CONTACT, self.onContact ,self )
	world:addEventListener( Event.END_CONTACT , self.endContact ,self)
	
	--update the position  of balls (i.e dynamic bodies)  every frame
	--Also you can add and remove the ball and its body only  onEnterFrame function , as world update itself in it.
	self:addEventListener( Event.ENTER_FRAME, self.onEnterFrame , self )
	self.ongameComplete = true
	
	print("The number of child billiard balls has in the beginning " , self:getNumChildren())
		
end

function billiardBalls : physicsPropertyOfBall( ball )
	
	local body = world:createBody{ type = b2.DYNAMIC_BODY }
	body.name = "ball"
	body:setPosition( ball:getX(),ball:getY())
	body:setLinearDamping(2)
	body:setAngularDamping(2)
	
	--Inner Fixture are the actual shapes of the images in the game and detect and react to collision
	local innerCircle = b2.CircleShape.new(0,0,20)
	local innerFixture = body:createFixture{ shape = innerCircle, density = 1, friction = 1, restitution = 0.8 }
	--All the balls will collide with other balls and walls
	innerFixture:setFilterData{ categoryBits = BALLS_MASK, maskBits = BALLS_MASK+WALLS_MASK + PreView_Mask }
	
	--outerFixture are bigger by the radius of the ball, so that the inner fixtures of objects will just touch each other 
	--instead of overlapping . And the outer Fixtures  of objects will overlap 
	local outerCircle = b2.CircleShape.new(0,0,40)
	local outerfixture = body:createFixture{shape = outerCircle, density = 1, friction = 1, restitution = 0.8 }
	outerfixture:setFilterData{ categoryBits = REFERENCE_BALLMASK , maskBits = 1 , groupIndex = -3 }
	
	ball.body = body
	ball.fixture = innerFixture  -- for reference
	
end

function billiardBalls:onContact(e)
		
	local fixtureA = e.fixtureA
	local fixtureB = e.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB :getBody()
	print("begin contact: "..bodyA.name.."<->"..bodyB.name)
	
	if( bodyA.name =="Pockets" and bodyB.name == "ball" )then
	
		bodyB.delete = true

	end
	
	if( bodyA.name == "reload" and bodyB.name =="ball" )then
	
		self.reloadobj.cueballNotPlaceableIndicator:setVisible(true)
		
	end
	
	if( bodyA.name =="Pockets" and bodyB.name == "reload" )then
	
		self.reloadobj.cueballNotPlaceableIndicator:setVisible(true)
		
	end
		
end
function billiardBalls:endContact(e)

	local fixtureA = e.fixtureA
	local fixtureB = e.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB :getBody()
	
	if( bodyA.name == "reload" and bodyB.name =="ball" )then
		print("Black Ball and Colored ball")
		self.reloadobj.cueballNotPlaceableIndicator:setVisible(false)
		
	end
	
	if( bodyA.name =="Pockets" and bodyB.name == "reload" )then
	
		self.reloadobj.cueballNotPlaceableIndicator:setVisible(false)
		
	end
end

function billiardBalls:addCueball(x,y)

	self.cueBall = Bitmap.new(Texture.new("img/cueball.png"))
	self.cueBall:setAnchorPoint(0.5,0.5)
	self.cueBall:setPosition( x ,y)
	self:physicsPropertyOfBall(self.cueBall)
	self:addChild(self.cueBall)
	self.cueBall.name = "cueBall"

end

function billiardBalls:onEnterFrame() 
	local gameComplete = true
	world:step(1/60, 8,3)
	local zeroVelocityObjects =0 
	
	--Reverse for loop in which last in first out (lifo) is applied 
	--for better explaination refer http://howto.oz-apps.com/2011/09/tower-of-babel-no-honoi-maybe.html
	print("NUmber Of Children Billiard has " ,self:getNumChildren())
	for i = self:getNumChildren() , 1,-1  do
	if self:getNumChildren()==2 and self.ongameComplete == true then
		sceneManager:changeScene("onGameComplete", 1, conf.transition, conf.easing)
		self.ongameComplete = false
	end
	
	if self:getNumChildren() == 2 and self.ongameComplete == true
	then
		sceneManager:changeScene("onGameComplete", 1, conf.transition, conf.easing)
		
	end
	
		--get specific sprite
		local sprite = self:getChildAt(i)
		
		-- check if sprite HAS a body (ie, physical object reference we added)
		if sprite.body  then
		
			--update position to match box2d world object's position
			--get physical body reference
			local body = sprite.body
			--get body coordinates
			local bodyX, bodyY = body:getPosition()
				-- If all the balls are at rest then let the user play , otherwise wait till the balls comes at rest
				if body:getLinearVelocity() == 0 and body.name == "ball" then
				
					zeroVelocityObjects = zeroVelocityObjects + 1
					
					if(zeroVelocityObjects == self:getNumChildren()-1 and self.cueBall ~= nil)then
					
						print("ZeroVelocity objects are " ,zeroVelocityObjects)
						print("NUmber of billiardball object  " ,self:getNumChildren() )
						self.projectionObj.projectBall:setVisible(true)
						self.projectionObj:defaultLengthOfRaycast()
						self.projectionObj:addEventListener(Event.MOUSE_DOWN , self.projectionObj.onMouseDown , self.projectionObj)
						self.projectionObj:addEventListener(Event.MOUSE_MOVE, self.projectionObj.onMouseMove,self.projectionObj)
						self.projectionObj:addEventListener(Event.MOUSE_UP, self.projectionObj.onMouseUp, self.projectionObj) 
						
					end
					
				end
			
			--apply coordinates to sprite
			sprite:setPosition(bodyX, bodyY)
			if( sprite.body.delete )then
				
				world:destroyBody(body)
				sprite.body.delete = false
				self:removeChild(sprite)
			
				
				if sprite.name == "cueBall"  then	--if the deleted ball is cueball
					self.cueBall = nil
					self.reloadobj = ReloadThecueBall.new(self)
					print("when reload created Preview of cueball" , self.cueballPositionPreview)
					self:addChild(self.reloadobj)
					
				end
				
				if sprite.body.name =="reload" then 
				
					self:addCueball(self.reloadobj.SetX , self.reloadobj.SetY )
					self.projectionObj.cueBallObj = nil
					self.projectionObj.cueBallObj =self.cueBall
					self:removeChild(self.reloadobj)
					print("when reload remove Preview of cueball" , self.cueballPositionPreview)
					self.reloadobj = nil
					
				end
				
			end
			
		end
	end
end

