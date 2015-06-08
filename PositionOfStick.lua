PositionOfStick = Core.class(Sprite)


--input should be position of cueball and position of project ball
--First just calculate the initial position of stick and move the stick around the ball

function PositionOfStick :init(cueballObj , projectBall)

	self.cueballObj = cueballObj	--cueball obj is needed to position the stick with respect to cueball position
	self.projectball = projectBall
	self.billiardStick = Bitmap.new(Texture.new("img/stick.png"))
	self.billiardStick:setAnchorPoint(1,1)
	
	local body = world:createBody{ type = b2.DYNAMIC_BODY }
	self.billiardStick.body = body
	self:calcPositionOfStick(self.projectball ,30)
	body.name = "stick"
	body:setLinearDamping(2)
	body:setAngularDamping(10)
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(5,5 ,1,1 ,0)
	
	local fixture = body:createFixture{ shape = poly, density = 0, friction = 1, restitution = 0.8 }
	fixture:setFilterData{categoryBits = BILLIARD_STICK_MASK, maskBits = BALLS_MASK  ,groupIndex = -3}
	
	self:addChild(self.billiardStick)
end

function PositionOfStick:calcPositionOfStick(projectBallObj , tempRadius)
-----With the change in projecting path of cueball , the hit position and direction of stick should also get updated.-----
	--Stick should always be in direction of  projecting path (i.e projectball and stick will be in one line)
	--And position of stick will always be around or at the rim of cueball
	--we know the postion of projectball and position of cueball  and have to calculate the position of stick
	-- lets assigned the knows position of balls
	local X_cueball, Y_cueball , X_projectball , Y_projectball
	X_cueball= self.cueballObj:getX()
	Y_cueball = self.cueballObj:getY()
	X_projectball = projectBallObj:getX()
	Y_projectball = projectBallObj:getY()
	
	--Stick should be at distance of radius of cueball from the position or centre of cueball .
	local hypo = tempRadius 
		
	--Till now we know the distance of stick from the cueball , which is not enough to position the stick we need
	--to calculate the exact position of stick at that distance and change the direction stick  which is towards project ball.
	--To find the position of stick
		--we have to calculate a point which is on :
		--the rim of cueball , on the projecting path and between the cueball and projectball.
		--using that point and slope of the projecting path we can position the stick with at the same angle of projecting path
	
	--step 1 : with the help of know position of cueball and projectball lets find the slope 
	
		local angle , X_difference,  Y_difference
		
		
		
	--find the x and y coordinate of the point or the length of the sides of triangle  using sin angle and cos angle
	local function sides_of_triangle (angle)
		local xside , yside
		xside = math.cos(angle) * hypo		--length of side of triangle
		yside = math.sin(angle) * hypo		--length of another side of triangle
		--print(" Xlength and Ylength of triangle : " , xside , yside)
		return xside ,yside
	end
		
		
	-- if the user click in the fourth quadrant the stick will be in the second quadrant
	if(X_projectball >= X_cueball and Y_projectball >= Y_cueball) then  -- fourth quadrant
	--	calculate the slope and angle made by the line
		X_difference = X_projectball - X_cueball
		Y_difference = Y_projectball - Y_cueball
		--print("X_difference , Y_difference : " , X_difference , Y_difference)
		angle = math.atan( Y_difference / X_difference )
		--print("Angle in radian = ", angle)
		local angle_degree = math.deg(angle)
		--print("slope or tan angle : " , degree_angle)

	--Boundaries of angle for the stick in the second quadrant 
		local default_angle = 0 
		local xside, yside , Px, Py
		xside , yside = sides_of_triangle(angle)
	--calculate the diagonal point in the second quadrant
		Px = X_cueball- xside
		Py = Y_cueball - yside
		--print("calculated X and Y position of stick : " , Px , Py)
		self.billiardStick:setPosition(Px,Py)
		local angle_of_stick = self.billiardStick:setRotation(angle_degree)
		self.billiardStick.body:setPosition(Px,Py)
		self.billiardStick.body:setAngle(angle)
		--print("Angle of stick : " , angle_of_stick )
	end

	--if the user click the third quadrant the stick will be in the first quadrant
	if(X_projectball <= X_cueball and Y_projectball >= Y_cueball)then

	--	calculate the slope and angle made by the line
		X_difference = X_cueball- X_projectball
		Y_difference = Y_projectball - Y_cueball
		--print("X_difference , Y_difference : " , X_difference , Y_difference)
		angle = math.atan( Y_difference / X_difference )
		--print("Angle in radian = ", angle)
		local angle_degree = math.deg(angle)
		--print("slope or tan angle : " , angle_degree)

	--Boundaries of angle for the stick in the first quadrant 
		local default_angle = 180
		local inclination_of_stick = default_angle - angle_degree
		local xside, yside , Px, Py
		xside , yside = sides_of_triangle(angle)
	--calculate the diagonal point in the first quadrant
		Px = X_cueball+ xside
		Py = Y_cueball - yside
		--print("calculated X and Y position of stick : " , Px , Py)
		self.billiardStick:setPosition(Px,Py)
		self.billiardStick.body:setPosition(Px,Py)
		local angle_of_stick = self.billiardStick:setRotation(inclination_of_stick)
		self.billiardStick.body:setAngle(angle)
		--print("Angle of stick : " , inclination_of_stick )

		
	end

	-- if the user clicks in the second quadrant the stick will be in the fourth quadrant
	if(X_projectball <= X_cueball and Y_projectball <= Y_cueball)then
	--	calculate the slope and angle made by the line
		X_difference = X_projectball - X_cueball
		Y_difference = Y_projectball - Y_cueball
		--print("X_difference , Y_difference : " , X_difference , Y_difference)
		angle = math.atan( Y_difference / X_difference )
		--print("Angle in radian = ", angle)
		local angle_degree = math.deg(angle)
		--print("slope or tan angle " , angle_degree)

	--Boundaries of angle for the stick in the fourth quadrant 
		local default_angle = 180
		local inclination_of_stick = default_angle + angle_degree
		local xside, yside , Px, Py
		xside , yside = sides_of_triangle(angle)
	--calculate the diagonal point in the fourth quadrant
		Px = X_cueball- xside
		Py = Y_cueball - yside
		--print("calculated X and Y position of stick : " , Px , Py)
		self.billiardStick:setPosition(Px,Py)
		local angle_of_stick = self.billiardStick:setRotation(angle_degree)
		
		--print("Angle of stick : " , angle_of_stick )
		
		Px = X_cueball+ xside
		Py = Y_cueball + yside
		--print("calculated X and Y position of stick : " , Px , Py)
		self.billiardStick:setPosition(Px,Py)
		self.billiardStick.body:setPosition(Px,Py)
		local angle_of_stick = self.billiardStick:setRotation(inclination_of_stick)
		self.billiardStick.body:setAngle(angle)
		--print("Angle of stick : " , angle_of_stick )
	end

	--if the user clicks in the first quadrant then the stick will be in the third quadrant
	if(X_projectball >= X_cueball and Y_projectball <= Y_cueball)then
		--	calculate the slope and angle made by the line
		X_difference = X_projectball - X_cueball
		Y_difference = Y_cueball - Y_projectball
		--print("X_difference , Y_difference : " , X_difference , Y_difference)
		angle = math.atan( Y_difference / X_difference )
		--print("Angle in radian = ", angle)
		local angle_degree = math.deg(angle)
		--print("slope or tan angle" , math.deg(angle))

	--Boundaries of angle for the stick in the third quadrant 
		local default_angle = 360
		local inclination_of_stick = 360 - angle_degree
		local xside, yside , Px, Py
		xside , yside = sides_of_triangle(angle)
	--calculate the diagonal point in the third quadrant
		Px = X_cueball- xside
		Py = Y_cueball + yside
		--print("calculated X and Y position of stick : " , Px , Py)
		self.billiardStick:setPosition(Px,Py)
		self.billiardStick.body:setPosition(Px,Py)
		local angle_of_stick = self.billiardStick:setRotation(inclination_of_stick)
		self.billiardStick.body:setAngle(angle)
		--print("Angle of stick : " , inclination_of_stick )
		
	end


end