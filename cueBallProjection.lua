--[[In this class we are just going to plot the projection path of the cue ball, which will show us how ball is
	going to hit another ball or wall and at what angle ]]--
	
require"box2d"

 cueBallProjection = Core.class(Sprite)
 
 --local world = b2.World.new(0,10,true)
 
 function cueBallProjection:init(world)
	self.cueball , self.projectball = self:balls()
	self.world =b2.World.new(0,10,true)
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
 end
 
 function cueBallProjection:balls()
	local cueBall = Bitmap.new(Texture.new("img/cueball.png"))
	cueBall:setAnchorPoint(0.5,0.5)
	local projectBall = Bitmap.new(Texture.new("img/projectedCueBall.png"))
	projectBall:setAnchorPoint(0.5,0.5)
	cueBall:setPosition(100,100)
	projectBall:setPosition(300, 300)
	
	--let create physics property of this ball
	self:ballPhysics(cueBall)
	
	self:addChild(cueBall)
	self:addChild(projectBall)
	return cueball , projectBall
 end
 
 function cueBallProjection:ballPhysics(ball)
	local body = self.world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(ball:getX(),ball:getY())
	local circle = b2.CircleShape.new(0,0,25)
	local fixture = body:createFixture{shape = circle, density = 500.0, 
	friction = 1, restitution = 0.8}
	ball.body = body

end
 
 function cueBallProjection:onEnterFrame()
 self.world:step(1/60, 1,3)
 end
 