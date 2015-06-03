--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Game Template for developing games. Includes: 
 * Start scene, pack select, level select, settings, score system and much more
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Gideros-Mobile-Game-Template
**************************************************************
]]--
require "box2d"
level = gideros.class(Sprite)

function level:init()
	
--lets create an interactive world , where all the objects/actors of the game will be added

world = b2.World.new(0, 0, true) --global world

local createTable = billiardTable.new()
self:addChild(createTable)

self.createBall = billiardBalls.new(createTable.table)
self:addChild(self.createBall)

--self.createBall:addEventListener( Event.ENTER_FRAME, self.onEnterFrame , self )
self.ongameComplete = true
end

--removing event
--[[function level:onEnterFrame() 
	local self1 = self.createBall
	local gameComplete = true
	world:step(1/60, 8,3)
	local zeroVelocityObjects =0 
	
	--Reverse for loop in which last in first out (lifo) is applied 
	--for better explaination refer http://howto.oz-apps.com/2011/09/tower-of-babel-no-honoi-maybe.html
	print("NUmber Of Children Billiard has " ,self:getNumChildren())
	for i = self1:getNumChildren() , 1,-1  do
	if self1:getNumChildren()==2 and self.ongameComplete == true then
		sceneManager:changeScene("onGameComplete", 1, conf.transition, conf.easing)
		self.ongameComplete = false
	end
	
	if self1:getNumChildren() == 2 and self1.ongameComplete == true
	then
		sceneManager:changeScene("onGameComplete", 1, conf.transition, conf.easing)
		
	end
	
		--get specific sprite
		local sprite = self1:getChildAt(i)
		
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
					
					if(zeroVelocityObjects == self1:getNumChildren()-1 and self1.cueBall ~= nil)then
					
						print("ZeroVelocity objects are " ,zeroVelocityObjects)
						print("NUmber of billiardball object  " ,self1:getNumChildren() )
						self1.projectionObj.projectBall:setVisible(true)
						self1.projectionObj:defaultLengthOfRaycast()
						self1.projectionObj:addEventListener(Event.MOUSE_DOWN , self1.projectionObj.onMouseDown , self1.projectionObj)
						self1.projectionObj:addEventListener(Event.MOUSE_MOVE, self1.projectionObj.onMouseMove,self1.projectionObj)
						self1.projectionObj:addEventListener(Event.MOUSE_UP, self1.projectionObj.onMouseUp, self1.projectionObj) 
						
					end
					
				end
			
			--apply coordinates to sprite
			sprite:setPosition(bodyX, bodyY)
			if( sprite.body.delete )then
				
				world:destroyBody(body)
				sprite.body.delete = false
				self1:removeChild(sprite)
			
				
				if sprite.name == "cueBall"  then	--if the deleted ball is cueball
					self1.cueBall = nil
					self1.reloadobj = ReloadThecueBall.new(self1)
					print("when reload created Preview of cueball" , self1.cueballPositionPreview)
					self1:addChild(self1.reloadobj)
					
				end
				
				if sprite.body.name =="reload" then 
				
					self1:addCueball(self1.reloadobj.SetX , self1.reloadobj.SetY )
					self1.projectionObj.cueBallObj = nil
					self1.projectionObj.cueBallObj =self1.cueBall
					self1:removeChild(self1.reloadobj)
					print("when reload remove Preview of cueball" , self1.cueballPositionPreview)
					self1.reloadobj = nil
					
				end
				
			end
			
		end
	end
end]]--

--removing event on exiting scene
function level:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end