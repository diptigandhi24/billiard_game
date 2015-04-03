--[[In this class we are just going to plot the projection path of the cue ball, which will show us how ball is
	going to hit another ball or wall and at what angle ]]--
	
 require"box2d"

 cueBallProjection = Core.class(Sprite)
 
 
 function cueBallProjection:init(billiardworldobj)
	self.world = billiardworldobj
	
	--create ball object
	self.cueBall = self:createballs("img/cueball.png",400 , 400 )
	self.projectBall = self:createballs("img/projectedCueBall.png", 600,400)  
	self.coloredBall = self:createballs("img/colouredBall.png" ,  800,500)
	
	--lets create identity of balls in box2d world
	
	self:physicsPropertyOfBall(self.cueBall , b2.DYNAMIC_BODY)
	self:physicsPropertyOfBall(self.coloredBall , b2.DYNAMIC_BODY)
	
	--when the screen is loaded ,lets show the default projected path of the cueBall
	self.slingshot = Shape.new()
	self.slingshot:setLineStyle(3, 0x0000FF,1)
	self.slingshot:beginPath()
	self.slingshot:moveTo(self.cueBall:getX(),self.cueBall:getY())
	self.slingshot:lineTo(self.projectBall:getX(), self.projectBall:getY())
	self.slingshot:endPath()
	
	self:addChild(self.slingshot)
	self:addChild(self.cueBall)
	self:addChild(self.projectBall)
	self:addChild(self.coloredBall)
	
	--Default projected path of the ball will be  in the direction of user touch and till the  start of the wall.
	--To find that point on the wall 
	self.pointobj = pointsOnAline.new()
	
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.MOUSE_DOWN , self.onMouseDown , self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove,self)
	--self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	
	

 end
 
 function cueBallProjection:createballs( image_url,x , y )
	
	local ball = Bitmap.new(Texture.new(image_url))
	ball:setAnchorPoint(0.5,0.5)
	ball:setPosition(x , y)
	return ball
end

 
 function cueBallProjection:physicsPropertyOfBall(ball, bodytype)
 
	local body = self.world:createBody{type = bodytype}
	body:setPosition(ball:getX(),ball:getY())
	local circle = b2.CircleShape.new(0,0,25)
	local fixture = body:createFixture{shape = circle, density = 0, 
	friction = 1, restitution = 0.8}
	ball.body = body
	ball.fixture = fixture

end

 function cueBallProjection:raycastCallback (fixture ,hitx , hity , vecx ,vecty,fraction  )
		print("hit the fixture yeahhhhhhhhh")
		self.slingshot:clear()
		self.slingshot:setLineStyle(3, 0x0000FF,1)
		self.slingshot:beginPath()
		self.slingshot:moveTo(self.cueBall:getX(),self.cueBall:getY())
		self.slingshot:lineTo(hitx , hity)
		self.slingshot:endPath()
	print("fractionnnnnnnnn : " , fraction)
	return fraction


	
	
end
function cueBallProjection : onMouseDown(event)
		self.pointobj: twopointSlope(self.cueBall:getX(),self.cueBall:getY(),event.x,event.y)
		self.world:rayCast(self.cueBall:getX() ,self.cueBall:getY(),self.pointobj.Xraycastpoint2 ,
		self.pointobj.Yraycastpoint2, self.raycastCallback ,self )
		
end

function cueBallProjection : onMouseMove(event)
		self.pointobj: twopointSlope(self.cueBall:getX(),self.cueBall:getY(),event.x,event.y)
		self.world:rayCast(self.cueBall:getX() ,self.cueBall:getY(),self.pointobj.Xraycastpoint2 ,
		self.pointobj.Yraycastpoint2, self.raycastCallback ,self )
		

end
function cueBallProjection : onMouseUp(event)

	if self.mousejoint ~= nil then
		self.projectBall:setPosition(event.x ,event.y)
		self.projectBall.body:setLinearDamping(10)
		self.world:destroyJoint(self.mousejoint)
		self.mousejoint = nil
	end
	
end

function cueBallProjection:onContact()
	self.coloredBall:setLinearVelocity(self.cueBall:getLinearDamping())
end
 function cueBallProjection:onEnterFrame()
	self.world:step(1/60, 8,3)
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
 