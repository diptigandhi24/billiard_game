onGameComplete = gideros.class(Sprite)

function onGameComplete:init()
	--[[local display = Shape.new()
	display:setFillStyle(Shape.SOLID, 0xff0000, 1)
	display:beginPath()
	display:moveTo(300,300)
	display:lineTo(600,300)
	display:lineTo(600 , 600)
	display:lineTo(300,600)
	display:closePath()
	display:endPath()
	self:addChild(display)]]--
	local scene = Bitmap.new(Texture.new("images/scene1.jpg"))
	self:addChild(scene)
	local congo = TextField.new(nil , "Congratulations!!!")
	congo:setLetterSpacing(2)
	congo:setScaleX(5)
	congo:setScaleY(5)
	congo:setPosition(300,300)
	self:addChild(congo)
	local question = TextField.new(nil , "Would you like to play again ? ")
		question:setScaleX(5)
		question:setScaleY(5)
		question:setPosition(400,400)
		self:addChild(question)
	
	
	self:addEventListener("enterEnd", self.onEnterEnd, self)

end

function onGameComplete :onEnterEnd()
	local button = Button.new(Bitmap.new(Texture.new("images/start_up.png", conf.textureFilter)), Bitmap.new(Texture.new("images/start_down.png", conf.textureFilter)))
		button:setPosition(500,500)
		self:addChild(button)
	button:addEventListener("click", function()
	
		--go to pack select scene
		sceneManager:changeScene("level", 1, conf.transition, conf.easing) 
	end)
end