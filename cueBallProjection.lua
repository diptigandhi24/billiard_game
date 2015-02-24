--[[In this class we are just going to plot the projection path of the cue ball, which will show us how ball is
	going to hit another ball or wall and at what angle ]]--
	
 require"box2d"

 cueBallProjection = Core.class(Sprite)
 
 
 function cueBallProjection:init(billiardworldobj)
	self.world = billiardworldobj
	self:balls()
	print("world object in cueBallProjection" , self.world)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.MOUSE_DOWN , self.onMouseDown , self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove,self)

 end
 
 function cueBallProjection:balls()
	--create a cueball object
	self.cueBall = Bitmap.new(Texture.new("img/cueball.png"))
	self.cueBall:setAnchorPoint(0.5,0.5)
	self.cueBall:setPosition(200,300)
	
	--create a projectball object
	self.projectBall = Bitmap.new(Texture.new("img/projectedCueBall.png"))
	self.projectBall:setAnchorPoint(0.5,0.5)
	self.projectBall:setPosition(400, 300)
	
	--let create physics property of this ball
	self:ballPhysics(self.cueBall)
	self:ballPhysics(self.projectBall)
	--self.projectBall.body:setLinearDamping(1)
	self.projectBall.body:setAngularDamping(1)
	--lets create projected path between the cueball and the projected ball
	self.slingshot = Shape.new()
	
	--default and intial  value of mousejoint
	self.mouseJoint = nil
	--creating dummy body
	self.ground = self.world:createBody({})
	
	--lets add the balls with there physics properties to the sprite objeect
	self:addChild(self.slingshot)
	self:addChild(self.cueBall)
	self:addChild(self.projectBall)
	
	self:defaultjoint()

 end
 
 function cueBallProjection:ballPhysics(ball)
	local body = self.world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(ball:getX(),ball:getY())
	local circle = b2.CircleShape.new(0,0,25)
	local fixture = body:createFixture{shape = circle, density = 500.0, 
	friction = 1, restitution = 0.8}
	ball.body = body

end

-- lets create the default mouse joint between the cueball and projectball

function cueBallProjection :defaultjoint()
	--[[local jointDef = b2.createMouseJointDef(self.cueBall.body , self.projectBall.body ,self.cueBall:getX() , self.cueBall:getY() , 10000)
	self.mouseJoint = self.world:createJoint(jointDef)
	self.mouseJoint:setTarget(self.projectBall:getX(), self.projectBall:getY())]]--
	self.slingshot:clear()
	self.slingshot:setLineStyle(3, 0x0000FF,1)
	self.slingshot:beginPath()
	self.slingshot:moveTo(self.cueBall:getX(),self.cueBall:getY())
	self.slingshot:lineTo(self.projectBall:getX(), self.projectBall:getY())
	self.slingshot:endPath()
end

function cueBallProjection : onMouseDown(event)
	if(self.projectBall:hitTestPoint(event.x , event.y)) then
		print("Mouse down X and Y points" ,event.x , event.y)
		--self.startpoint.X = event.x
		--self.startpoint.Y = event.y
		local jointDef = b2.createMouseJointDef(self.ground , self.projectBall.body ,event.x , event.y,1000000)
		self.mousejoint = self.world:createJoint(jointDef)
	end
end

function cueBallProjection : onMouseMove(event)
	print("Mouse Move X and Y points" ,event.x , event.y)
	if self.mousejoint ~= nil then
		self.mousejoint:setTarget(event.x , event.y)
		self.slingshot:clear()
		self.slingshot:setLineStyle(3, 0x0000FF,1)
		self.slingshot:beginPath()
		self.slingshot:moveTo(self.cueBall:getX(),self.cueBall:getY())
		self.slingshot:lineTo(event.x,event.y)
		self.slingshot:endPath()
	end

end

 
 function cueBallProjection:onEnterFrame()
	self.world:step(1/60, 1,3)
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
 