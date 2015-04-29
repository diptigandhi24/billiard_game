 RaycastPoints = Core.class()
 
--we need two points for the raycast , one point the curball position and one point at the edge/wall of  the table 
-- this class will help us to find the point on the line of cueball x & y and usertouch x & y ,  at the boundary of table  
function  RaycastPoints :init()
end

function RaycastPoints : directionofRaycast(Xcueball ,Ycueball , Xtouch ,Ytouch)
	--Find the direction in which user has clicked using cueball position.
	--Reference points on the wall is used to refer wheather ball has hit maximum or minimum side of wall.
	if (Xtouch >= Xcueball)then
		self.XrefpointofRaycast = 1199
	else
		self.XrefpointofRaycast = 0
	end
	if (Ytouch >= Ycueball)then
		self.YrefpointofRaycast = 686
	else
		self.YrefpointofRaycast = 0 
	end
	print("User X and Y touch " , Xtouch , Ytouch)
	print("Reference point on the wall is " , self.XrefpointofRaycast ,self.YrefpointofRaycast)
	print("X and Y of CueBall " , Xcueball , Ycueball)
end

--Default raycast length will be from cueball to the end of the table
-- this is mathematical function calculating exact raycast points using two-points slope method
function RaycastPoints : lengthofRaycast(Xcueball ,Ycueball ,Xtouch ,Ytouch)
	self.Xcueball = Xcueball
	self.Ycueball = Ycueball
	self.Xtouch = Xtouch
	self.Ytouch = Ytouch
	self:directionofRaycast(self.Xcueball ,self.Ycueball , self.Xtouch ,self.Ytouch)
	local slope = (self.Ycueball - self.Ytouch) / (self.Xcueball - self.Xtouch) 
	print("Slope Of ray cast " , slope)
	
-- y-y1 = m (x-x1)  , where y1 and x1 are the know points and x and y are unknow exactraycast point
--lets first find y
	local tmpY = (slope *(self.XrefpointofRaycast - self.Xcueball)) + self.Ycueball
	--print("tmpY : " ,tmpY)
	if(tmpY >= 0 and tmpY <=686)then
		self.Yraycastpoint2 = tmpY
		print(" Y Value is temporary" , self.Yraycastpoint2)
	else 
		self.Yraycastpoint2 = self.YrefpointofRaycast
		print(" Ys reference value" , self.Yraycastpoint2)
	end
	
--similarly 
	local tmpX = ((self.YrefpointofRaycast -self.Ycueball) / slope ) + self.Xcueball
	if(tmpX >=0 and tmpX <= 1199)
	then
		
		self.Xraycastpoint2 = tmpX
		print(" X Value is temporary" ,self.Xraycastpoint2)
	else
		self.Xraycastpoint2= self.XrefpointofRaycast
		print(" X reference value" ,self.Xraycastpoint2)
	end
	
end