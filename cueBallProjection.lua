require"box2d"

cueBallProjection = Core.class(Sprite)
 
 
 function cueBallProjection:init( cueBallObj , billiardTableObj)
 
	self.cueBallObj = cueBallObj
	self.billiardTableObj = billiardTableObj
	
	--lets create  project object 
	self.projectBall =Bitmap.new(Texture.new("img/projectedCueBall.png"))
	self.projectBall:setPosition(600 , 400)
	self.projectBall:setAnchorPoint(0.5,0.5)
	self:addChild(self.projectBall)
	
	
	--------when the screen is loaded ,lets create the default project path of the cueBall, following are the steps------
	
	--initialise the shape object , which will be use to create path
	self.slingshot = Shape.new()
	
	--To calculate the path till the end of table in the user selected direction we use the RaycastPoints class
	--this class calculates the second point of raycast, which by default should be at the end of table in user  selected direction
	self.raycastlength = RaycastPoints.new()	
	--show the initial projection of  cueball,when screen is loaded 
	self:defaultLengthOfRaycast()		
	
	--------once you correctly aim at the ball, next thing you will like to decide how hard you want to hit the cueball------
	--let create and add the forcestrip to the class
	self:createForceStrip()
	
	--Following events are for billiardtable and forcestrip , used for projection and hitting the cueball
	self:addEventListener(Event.MOUSE_DOWN , self.onMouseDown , self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove,self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	
	

 end
 
 function cueBallProjection :defaultLengthOfRaycast()
	--Raycast detects the objects in the projected  path of the cueball  .
	--path will always be drawn till the end of the table if there is no other ball in the way.
	--OR else path will be drawn till the ball .
	self.raycastlength :lengthofRaycast(self.cueBallObj:getX(),self.cueBallObj:getY(),self.projectBall:getX(),self.projectBall:getY())
						world:rayCast(self.cueBallObj:getX() ,self.cueBallObj:getY(),self.raycastlength.Xraycastpoint2 ,
						self.raycastlength.Yraycastpoint2, self.raycastCallback ,self )
						
 end
 

 --If the raycast detects an object in the path of cueball projection , then show the projection till the object detected .
 function cueBallProjection:raycastCallback (fixture ,hitx , hity , vecx ,vecty,fraction  )
		
		
		self.targetx = hitx
		self.targety = hity
		self.projectBall:setPosition(hitx ,hity)
		self.slingshot:clear()
		self.slingshot:setLineStyle(3, 0x0000FF,1)
		self.slingshot:beginPath()
		self.slingshot:moveTo(self.cueBallObj:getX(),self.cueBallObj:getY())
		self.slingshot:lineTo(self.projectBall:getX() ,self.projectBall:getY())
		self.slingshot:endPath()
		self:addChild(self.slingshot)
		
	
	return fraction


	
	
 end
 function cueBallProjection : onMouseDown(event)
	local count = 0
	self.hitstrip = false
		
			for i=1 , 15
			do
				
				if (self.userSelectedForce[i]:hitTestPoint(event.x,event.y) )then
					
					self.hitstrip = true
					if(self.hitstrip == true )then
						self:showStrengthOnmouseDown( i )
						
					end
				end
				
				
			end
			if(self.billiardTableObj:hitTestPoint(event.x ,event.y) and self.hitstrip == false)then
					self.isFocus = true
					self.raycastlength: lengthofRaycast(self.cueBallObj:getX(),self.cueBallObj:getY(),event.x,event.y)
					world:rayCast(self.cueBallObj:getX() ,self.cueBallObj:getY(),self.raycastlength.Xraycastpoint2 ,
					self.raycastlength.Yraycastpoint2, self.raycastCallback ,self )
					--world:rayCast(self.cueBallObj:getX() ,self.cueBallObj:getY(),event.x ,event.y, self.raycastCallback ,self)
			
			end
			
		
		
 end

 function cueBallProjection : onMouseMove(event)
		local count = 0
		self.hitstrip2 = false
		for i=1 , 15 do
				
				if ( self.userSelectedForce[i]:hitTestPoint(event.x,event.y))then
					
				
					self.hitstrip2 = true
					if(self.hitstrip2 == true )then
						self:showStrengthOnmouseMove( i )
					end
					
				end
				count = count+1
		end

		if(self.billiardTableObj:hitTestPoint(event.x ,event.y) )then
				
					if self.isFocus == true then
					
						self.raycastlength: lengthofRaycast(self.cueBallObj:getX(),self.cueBallObj:getY(),event.x,event.y)
						world:rayCast(self.cueBallObj:getX() ,self.cueBallObj:getY(),self.raycastlength.Xraycastpoint2 ,
						self.raycastlength.Yraycastpoint2, self.raycastCallback ,self )
						world:rayCast(self.cueBallObj:getX() ,self.cueBallObj:getY(),event.x ,event.y, self.raycastCallback ,self)
					
					end
		end
		
		
		

 end
 function cueBallProjection : onMouseUp(event)
	self.hitstrip3 = false

	
	
	
	
	for i=1 , 15 do
				
				
				if (self.userSelectedForce[i]:hitTestPoint(event.x,event.y) )then
					self.hitstrip3 = true
					if(self.hitstrip3 == true )then
						self:removeStrengthIndicator( event )
						self.hitstrip3 = false
					end
				end
	end
	
	if(self.billiardTableObj:hitTestPoint(event.x ,event.y) and self.hitstrip3 == false)then
		self.isFocus = false
	end
	
	
	
 end

 function cueBallProjection : showStrengthOnmouseDown (stripNumber)
	
	for i= 1 , 15
	do
		if(self.userSelectedForce[i]:isVisible() == false and i<=stripNumber)
		then
			--hightlight the rectangle from the beginning till the selected one 
			self.userSelectedForce[i]:setVisible(true)
			
		end
		self.userSelectedForce[i].isFilled = true
		stage:addChild(self.userSelectedForce[i])

	end
 end

 function cueBallProjection : showStrengthOnmouseMove (stripNumber)
	for i= 1 , 15
	do
		
		--if the user is hovering from upto down , highlight the strip from top
		if self.userSelectedForce[i]:isVisible()== false and i<=stripNumber then
		
			self.userSelectedForce[i]:setVisible(true)
		else
			--self.userSelectedForce[i]:setVisible(false)
		
		end
		--if the user is hovering from bottom to up removing the highlight from bottom
		if self.userSelectedForce[i]:isVisible() == true and i>stripNumber then
			self.userSelectedForce[i]:setVisible(false)
		end
		
		

	end
 end
 function cueBallProjection : removeStrengthIndicator(event)
	for i = 1 , 15
	do
		self.userSelectedForce[i]:setVisible(false)
	
	end
	
		local strength = (event.y - 200)
	local tmpx = (self.projectBall:getX() - self.cueBallObj:getX()) *strength
	
	local tmpy = (self.projectBall:getY() - self.cueBallObj:getY()) *strength
	
	self.cueBallObj.body:applyForce(tmpx,tmpy,self.projectBall:getX(),self.projectBall:getY())
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
		--shows the force strip to select force
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
		
		-- shows user selected force
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
		
		
		y = y+20
		self:addChild(self.selectForce[i])
		self:addChild(self.userSelectedForce[i])
	end

 end




 
 