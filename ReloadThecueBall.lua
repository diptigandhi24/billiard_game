ReloadThecueBall = Core.class(Sprite)

function ReloadThecueBall:init(previewImage , noentryImage)
	self.repositionCueball = previewImage
	
	--To let the user know when the ball is on top of Another ball , we will use physics body 
	local body = world:createBody{type = b2.DYNAMIC_BODY}
		  body:setPosition(self.repositionCueball:getX(),self.repositionCueball:getY())
		  body.name = "reload"
		  body:setLinearDamping(100)
		  body:setAngularDamping(100)
	local circle = b2.CircleShape.new(0,0,20)
	local fixture = body:createFixture{shape = circle, density = 1, friction = 0, restitution = 0.1 }
		  fixture:setFilterData{categoryBits = PreView_Mask , maskBits =  BALLS_MASK   }
		  fixture:setSensor(true)
	self.repositionCueball.body = body	  
	self.repositionCueball:setVisible(true)
	
	self.notPlaceable = noentryImage
	--self.notPlaceable:setVisible(true)
	
	
	self.ground = world:createBody({})
	self.mouseJoint = nil
	
	--Note event is assign to object of this class
	self:addEventListener(Event.MOUSE_DOWN ,self.onMouseDown,self)
	self:addEventListener(Event.MOUSE_MOVE , self.onMouseMove,self)
	
	
	
	--world:addEventListener(Event.BEGIN_CONTACT, self.oncontact ,self )
	--world:addEventListener(Event.END_CONTACT , self.endcontact ,self)
	self.SetX = 0
	self.SetY = 0

end 

function ReloadThecueBall:boundaryForball(x , y)
	local posx , posy 
	
	if x <= 90 then  					
		posx = 90
	elseif x >=1123 then
			posx = 1115
			else posx = x
			
	end
	
	if(y <= 63 )then  					
		posy = 75
	elseif y >=621 then
			posy = 610
			else posy = y
	end
	
	self.mouseJoint:setTarget(posx ,  posy)
	self.repositionCueball:setPosition(posx ,posy)
	self.notPlaceable:setPosition(posx ,  posy)
	self.SetX = posx
	self.SetY = posy
end
function ReloadThecueBall : onMouseDown(event)
		print("callling Reload MOusedown")
		
			if self.repositionCueball:hitTestPoint(event.x , event.y)
			then
				if self.mouseJoint == nil then
				local jointDef = b2.createMouseJointDef(self.ground, self.repositionCueball.body, event.x, event.y, 100000)
				self.mouseJoint = world:createJoint(jointDef)
				self:boundaryForball(event.x ,event.y)
				else
					self:boundaryForball(event.x ,event.y)
				end
			end
	
end
 

function ReloadThecueBall :onMouseMove(event)

		print("callling Reload MOuseMOVE")
		--self:boundaryForball(event.x ,event.y)
		if self.mouseJoint ~= nil then
			self:boundaryForball(event.x ,event.y)
		end
		
		if self.notPlaceable:isVisible() == false
		then  
		self:addEventListener(Event.MOUSE_UP , self.onMouseUp,self)
		else
			self:removeEventListener(Event.MOUSE_UP , self.onMouseUp,self)
		end
end

function ReloadThecueBall :onMouseUp(event)
		print("callling Reload MOuseUP")
		if self.mouseJoint ~= nil then
			self:boundaryForball(event.x ,event.y)
			world:destroyJoint(self.mouseJoint)
			self.mouseJoint = nil
			self.repositionCueball.body.delete =true
			
		end
end