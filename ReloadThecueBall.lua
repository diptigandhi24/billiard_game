--This class lets the user select the new position of cueball . 
--And also tells if the selected position is valid to place the cueball .
ReloadThecueBall = Core.class(Sprite)

function ReloadThecueBall:init(billiardBallObj)

	local X_INTIAL_CUEBALLPOSITION = 200
	local Y_INTIAL_CUEBALLPOSITION = 400
	
	-- create the preview obj for the cueball. 
	self.cueballPositionPreview = Bitmap.new(Texture.new("img/reloadCueball.png"))
	self.cueballPositionPreview:setPosition(X_INTIAL_CUEBALLPOSITION ,Y_INTIAL_CUEBALLPOSITION)
	self.cueballPositionPreview:setAnchorPoint(0.5 , 0.5)
	billiardBallObj:addChild(self.cueballPositionPreview)
	
	--Physics body of preview obj is used to detect anyother body on the billiard table . 
	local body = world:createBody{type = b2.DYNAMIC_BODY}
		  body:setPosition(self.cueballPositionPreview:getX(),self.cueballPositionPreview:getY())
		  body.name = "reload"
		  body:setLinearDamping(100)
		  body:setAngularDamping(100)
	local circle = b2.CircleShape.new(0,0,20)
	local fixture = body:createFixture{shape = circle, density = 1, friction = 0, restitution = 0.1 }
		  fixture:setFilterData{categoryBits = PreView_Mask , maskBits =  BALLS_MASK   }
		  fixture:setSensor(true)
	self.cueballPositionPreview.body = body	  
	
	
	--if the user selected place is not correct then show Noentry idicator 
	
	self.cueballNotPlaceableIndicator = Bitmap.new(Texture.new("img/noentry.png"))
	self.cueballNotPlaceableIndicator:setAnchorPoint(0.5,0.5)
	self.cueballNotPlaceableIndicator:setPosition(X_INTIAL_CUEBALLPOSITION ,Y_INTIAL_CUEBALLPOSITION)
	self:addChild(self.cueballNotPlaceableIndicator)
	self.cueballNotPlaceableIndicator:setVisible(false)
	
	-- For Mousejoint create empty body
	self.ground = world:createBody({})
	self.mouseJoint = nil
	
	--Note event is assign to object of this class
	self:addEventListener(Event.MOUSE_DOWN ,self.onMouseDown,self)
	self:addEventListener(Event.MOUSE_MOVE , self.onMouseMove,self)
	
	
	
	--store and make the location of preview obj acessible
	self.SetX = 0
	self.SetY = 0

end 

function ReloadThecueBall:boundaryForball(x , y)

	local posx , posy 
	--lets create boundary  for previewobj ( i.e inside the table )
	local miniX , miniY , maxiX , maxiY
	miniX = 90
	maxiX = 1115
	miniY = 75
	maxiY = 610
	
	if x <= miniX then  					
		posx = miniX
	elseif x >=maxiX then
			posx = maxiX
			else posx = x
			
	end
	
	if(y <= miniY )then  					
		posy = miniY
	elseif y >=maxiY then
			posy = maxiY
			else posy = y
	end
	
	self.mouseJoint:setTarget(posx ,  posy)
	self.cueballPositionPreview:setPosition(posx ,posy)
	self.cueballNotPlaceableIndicator:setPosition(posx ,  posy)
	self.SetX = posx
	self.SetY = posy
	
end

function ReloadThecueBall : onMouseDown(event)
		
	if self.cueballPositionPreview:hitTestPoint(event.x , event.y)then
	
		if self.mouseJoint == nil then
		
			local jointDef = b2.createMouseJointDef(self.ground, self.cueballPositionPreview.body, event.x, event.y, 100000)
			self.mouseJoint = world:createJoint(jointDef)
			self:boundaryForball(event.x ,event.y)
			
		else
		
			self:boundaryForball(event.x ,event.y)
			
		end
		
	end
	
end
 

function ReloadThecueBall :onMouseMove(event)

		if self.mouseJoint ~= nil then
		
			self:boundaryForball(event.x ,event.y)
			
		end
		
		if self.cueballNotPlaceableIndicator:isVisible() == false then  
		
			self:addEventListener(Event.MOUSE_UP , self.onMouseUp,self)
		
		else
		
			self:removeEventListener(Event.MOUSE_UP , self.onMouseUp,self)
			
		end
		
end

function ReloadThecueBall :onMouseUp(event)

		if self.mouseJoint ~= nil then
		
			self:boundaryForball(event.x ,event.y)
			world:destroyJoint(self.mouseJoint)
			self.mouseJoint = nil
			self.cueballPositionPreview.body.delete =true
			
		end
		
end