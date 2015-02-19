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
	
 end
 
 function cueBallProjection:balls()
	--create a cueball object
	self.cueBall = Bitmap.new(Texture.new("img/cueball.png"))
	self.cueBall:setAnchorPoint(0.5,0.5)
	self.cueBall:setPosition(100,100)
	
	--create a projectball object
	self.projectBall = Bitmap.new(Texture.new("img/projectedCueBall.png"))
	self.projectBall:setAnchorPoint(0.5,0.5)
	self.projectBall:setPosition(300, 300)
	
	--let create physics property of this ball
	self:ballPhysics(self.cueBall)
	self:ballPhysics(self.projectBall)
	
	self:addChild(self.cueBall)
	self:addChild(self.projectBall)

 end
 
 function cueBallProjection:ballPhysics(ball)
	local body = self.world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(ball:getX(),ball:getY())
	local circle = b2.CircleShape.new(0,0,25)
	local fixture = body:createFixture{shape = circle, density = 500.0, 
	friction = 1, restitution = 0.8}
	ball.body = body

end

function cueBallProjection : onMouseDown(event)
	if(self.projectBall:hitTestPoint(event.x , event.y)) then
		self.startpoint.X = event.x
		self.startpoint.Y = event.y
		
	end
end

function cueBallProjection : onMouseMove(event)
	

end

 
 function cueBallProjection:onEnterFrame()
 self.world:step(1/60, 1,3)
 end
 