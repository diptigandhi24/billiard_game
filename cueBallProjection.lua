require"box2d"

cueBallProjection = Core.class(Sprite)
 
 
 function cueBallProjection:init(billiardworldobj , cueball , BitmapOftable)
 
	self.cueBall = cueball
	self.tableimage = BitmapOftable
	
	--lets add a projection of cueball
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
	
	--once you correctly aim at the ball, next thing you will like to decide how hard you hit the cueball
	self:createForceStrip()
	
	self:addEventListener(Event.MOUSE_DOWN , self.onMouseDown , self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove,self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	
	

 end
 
 function cueBallProjection:raycastCallback (fixture ,hitx , hity , vecx ,vecty,fraction  )
		
		
		local setx , sety
		self.targetx = hitx
		self.targety = hity
		self.projectBall:setPosition(hitx ,hity)
		self.slingshot:clear()
		self.slingshot:setLineStyle(3, 0x0000FF,1)
		self.slingshot:beginPath()
		self.slingshot:moveTo(self.cueBall:getX(),self.cueBall:getY())
		self.slingshot:lineTo(self.projectBall:getX() ,self.projectBall:getY())
		self.slingshot:endPath()
		
	
	return fraction


	
	
end
function cueBallProjection : onMouseDown(event)
	local count = 0
	self.hitstrip = false
		
			for i=1 , 15
			do
				
				if (self.userSelectedForce[i]:hitTestPoint(event.x,event.y) )then
					print("you have the stipr number : " , i)
					self.hitstrip = true
					if(self.hitstrip == true )then
						self:showStrengthOnmouseDown( i )
						
					end
				end
				count = count+1
				if(self.tableimage:hitTestPoint(event.x ,event.y) and self.hitstrip == false)then
			
					self.pointobj: twopointSlope(self.cueBall:getX(),self.cueBall:getY(),event.x,event.y)
					world:rayCast(self.cueBall:getX() ,self.cueBall:getY(),self.pointobj.Xraycastpoint2 ,
					self.pointobj.Yraycastpoint2, self.raycastCallback ,self )
			
				end
				
			end
			
		
		
end

function cueBallProjection : onMouseMove(event)
	local count = 0
	print("calling mouce moveeeeeeeeee" , self.hitstrip2)
	self.hitstrip2 = false
		for i=1 , 15
			do
				
				if ( self.userSelectedForce[i]:hitTestPoint(event.x,event.y))then
					
				
					self.hitstrip2 = true
					if(self.hitstrip2 == true )then
					print("Call MOUse move strength")
						self:showStrengthOnmouseMove( i )
					end
					
				end
				count = count+1
				if(self.tableimage:hitTestPoint(event.x ,event.y) and self.hitstrip2 == false)then
					print("chueeeeeeeeeeeeee")
					self.pointobj: twopointSlope(self.cueBall:getX(),self.cueBall:getY(),event.x,event.y)
					world:rayCast(self.cueBall:getX() ,self.cueBall:getY(),self.pointobj.Xraycastpoint2 ,
					self.pointobj.Yraycastpoint2, self.raycastCallback ,self )
				
				end
				
			end
			
		
		
		

end
function cueBallProjection : onMouseUp(event)
	print("calling mouse UPPPPPPP")
	self.hitstrip3 = false

	local tmpx = (self.projectBall:getX() - self.cueBall:getX()) *30
	
	local tmpy = (self.projectBall:getY() - self.cueBall:getY()) *30
	
	
	
	for i=1 , 15
			do
				
				
				if (self.userSelectedForce[i]:hitTestPoint(event.x,event.y) )then
					print("you have the stipr number : " , i)
					self.hitstrip3 = true
					if(self.hitstrip3 == true )then
						self:removeStrengthIndicator( event )
						self.hitstrip3 = false
					end
				end
	end
	
	
	
end

function cueBallProjection : showStrengthOnmouseDown (stripNumber)
	print("Show strength on MOuse Down")
	
	for i= 1 , 15
	do
		print("INSIDE FOR LOOP")
		if(self.userSelectedForce[i]:isVisible() == false and i<=stripNumber)
		then
			self.userSelectedForce[i]:setVisible(true)
			
		end
		self.userSelectedForce[i].isFilled = true
		stage:addChild(self.userSelectedForce[i])

	end
end

function cueBallProjection : showStrengthOnmouseMove (stripNumber)
	print("Show Strength on mouse Move")
	for i= 1 , 15
	do
		
		if self.userSelectedForce[i]:isVisible()== false and i<=stripNumber then
		
			self.userSelectedForce[i]:setVisible(true)
		else
			--self.userSelectedForce[i]:setVisible(false)
		
		end
		if self.userSelectedForce[i]:isVisible() == true and i>stripNumber then
			self.userSelectedForce[i]:setVisible(false)
		end
		
		

	end
end
function cueBallProjection : removeStrengthIndicator(event)
	print("Remove strengthtttttttttttt")
	for i = 1 , 15
	do
		self.userSelectedForce[i]:setVisible(false)
	
	end
	
		local strength = (event.y - 200)
		print("strength  : " ,strength)
	local tmpx = (self.projectBall:getX() - self.cueBall:getX()) *strength
	
	local tmpy = (self.projectBall:getY() - self.cueBall:getY()) *strength
	
	self.cueBall.body:applyForce(tmpx,tmpy,self.projectBall:getX(),self.projectBall:getY())
	self.slingshot:clear()
	self.projectBall:setVisible(false)
	self:removeEventListener(Event.MOUSE_DOWN , self.onMouseDown , self)
	self:removeEventListener(Event.MOUSE_MOVE, self.onMouseMove,self)
	self:removeEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	
end
function cueBallProjection : createForceStrip()
	local x =1225  y = 200
	self.selectForce ={}
	self.userSelectedForce = {}
	for i=1 ,15 do

		self.selectForce[i] = Shape.new()
		self.selectForce[i]:setLineStyle(2 ,0xff0000 )
		self.selectForce[i]:beginPath()
		self.selectForce[i]:moveTo(x , y)
		self.selectForce[i]:lineTo(x+50 ,y)
		self.selectForce[i]:lineTo(x+50 ,y+10)
		self.selectForce[i]:lineTo(x ,y+10)
		self.selectForce[i]:closePath()
		self.selectForce[i]:endPath()
		self.selectForce[i].isFilled = false
		
		
		self.userSelectedForce[i] = Shape.new()
		self.userSelectedForce[i]:setFillStyle(self.selectForce[i].SOLID, 0xff0000, 1)
		self.userSelectedForce[i]:beginPath()
		self.userSelectedForce[i]:moveTo(x , y)
		self.userSelectedForce[i]:lineTo(x+50 ,y)
		self.userSelectedForce[i]:lineTo(x+50 ,y+10)
		self.userSelectedForce[i]:lineTo(x ,y+10)
		self.userSelectedForce[i]:closePath()
		self.userSelectedForce[i]:endPath()
		self.userSelectedForce[i]:setVisible(false)
		
		
		y = y+15
		self:addChild(self.selectForce[i])
		self:addChild(self.userSelectedForce[i])
	end

end




 