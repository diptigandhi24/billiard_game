require"box2d"

cueBallProjection = Core.class(Sprite)
 
 
 function cueBallProjection:init(billiardworldobj , cueball)
 
	self.world = billiardworldobj
	self.cueBall = cueball
	
	--let create a projection of cueball
	self.projectBall =Bitmap.new(Texture.new("img/projectedCueBall.png"))
	self.projectBall:setPosition(600 , 400)
	self.projectBall:setAnchorPoint(0.5,0.5)
	self:addChild(self.projectBall)
	
	
	--when the screen is loaded ,lets show the default projected path of the cueBall
	self.slingshot = Shape.new()
	self.slingshot:setLineStyle(3, 0x0000FF,1)
	self.slingshot:beginPath()
	self.slingshot:moveTo(self.cueBall:getX(),self.cueBall:getY())
	self.slingshot:lineTo(self.projectBall:getX(), self.projectBall:getY())
	self.slingshot:endPath()
	self:addChild(self.slingshot)
	
	
	--Default projected path of the ball will be  in the direction of user touch and till the  start of the wall.
	--To find that point on the wall 
	--calculating the distance of cueball from the wall
	self.pointobj = pointsOnAline.new()
	
	
	--self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.MOUSE_DOWN , self.onMouseDown , self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove,self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	
	

 end
 
 function cueBallProjection:raycastCallback (fixture ,hitx , hity , vecx ,vecty,fraction  )
		
		--print("hit the fixture yeahhhhhhhhh")
		local setx , sety
		self.targetx = hitx
		self.targety = hity
		--print("Yposition of projectball" ,self.projectBall:getY())
		self.projectBall:setPosition(hitx ,hity)
		self.slingshot:clear()
		self.slingshot:setLineStyle(3, 0x0000FF,1)
		self.slingshot:beginPath()
		self.slingshot:moveTo(self.cueBall:getX(),self.cueBall:getY())
		self.slingshot:lineTo(self.projectBall:getX() ,self.projectBall:getY())
		self.slingshot:endPath()
		
	--print("fractionnnnnnnnn : " , fraction)
	return fraction


	
	
end
function cueBallProjection : onMouseDown(event)
		self.pointobj: twopointSlope(self.cueBall:getX(),self.cueBall:getY(),event.x,event.y)
		self.world:rayCast(self.cueBall:getX() ,self.cueBall:getY(),self.pointobj.Xraycastpoint2 ,
		self.pointobj.Yraycastpoint2, self.raycastCallback ,self )
		
		
		
end

function cueBallProjection : onMouseMove(event)
		self.pointobj: twopointSlope(self.cueBall:getX(),self.cueBall:getY(),event.x,event.y)
		
		world:rayCast(self.cueBall:getX() ,self.cueBall:getY(),self.pointobj.Xraycastpoint2 ,
		self.pointobj.Yraycastpoint2, self.raycastCallback ,self )
		
		
		

end
function cueBallProjection : onMouseUp(event)
	local tmpx = (self.projectBall:getX() - self.cueBall:getX()) *30
	
	local tmpy = (self.projectBall:getY() - self.cueBall:getY()) *30
	self.cueBall.body:applyForce(tmpx,tmpy,self.projectBall:getX(),self.projectBall:getY())
	self:removeEventListener(Event.MOUSE_DOWN , self.onMouseDown , self)
	self:removeEventListener(Event.MOUSE_MOVE, self.onMouseMove,self)
	self:removeEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	self.slingshot:clear()
	
end

function cueBallProjection:onContact()
	self.coloredBall:setLinearVelocity(self.cueBall:getLinearDamping())
end
 --[[function cueBallProjection:onEnterFrame()
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

 end]]--
 