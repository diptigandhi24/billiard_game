 pointsOnAline = Core.class()
 
--we need two points for the raycast , one point inside the table and one point outside the table 
-- this class will help us to find the point on the line of cueball x & y and usertouch x & y ,  at the boundary of table  
function  pointsOnAline :init()
end

function pointsOnAline : directionOfprojectBall(Xcueball ,Ycueball , Xtouch ,Ytouch)
	--Find the forward or backward direction of project ball and reference point on the wall
	
	if (Xtouch >= Xcueball)then
		self.XrefpointofWall = 1199
	else
		self.XrefpointofWall = 0
	end
	if (Ytouch >= Ycueball)then
		self.YrefpointofWall = 686
	else
		self.YrefpointofWall = 0 
	end
	--print("self.XrefpointofWall :",self.XrefpointofWall )
	--print("self.YrefpointofWall  : ",self.YrefpointofWall )
end

--lets calculate exact x and y raycast point on the line of cueball and user touch
-- this is mathematical function calculating exact raycast points using two-points slope method
function pointsOnAline : twopointSlope(Xcueball ,Ycueball ,Xtouch ,Ytouch)
	self.Xcueball = Xcueball
	self.Ycueball = Ycueball
	self.Xtouch = Xtouch
	self.Ytouch = Ytouch
	self:directionOfprojectBall(self.Xcueball ,self.Ycueball , self.Xtouch ,self.Ytouch)
	local slope = (self.Ycueball - self.Ytouch) / (self.Xcueball - self.Xtouch) 
	
-- y-y1 = m (x-x1)  , where y1 and x1 are the know points and x and y are unknow exactraycast point
--lets first find y
	local tmpY = (slope *(self.XrefpointofWall - self.Xcueball)) + self.Ycueball
	--print("tmpY : " ,tmpY)
	if(tmpY >= 0 and tmpY <=686)then
		--print("tmpyyyyyy")
		self.Yraycastpoint2 = tmpY
	else 
		self.Yraycastpoint2 = self.YrefpointofWall
	end
	
--similarly 
	local tmpX = ((self.YrefpointofWall -self.Ycueball) / slope ) + self.Ycueball
	--print("tmpX : " ,tmpX)
	--print()
	if(tmpX >=0 and tmpX <= 1199)
	then
		--print("tmpxxxxxxxxxx")
		self.Xraycastpoint2 = tmpX
	else
		self.Xraycastpoint2= self.XrefpointofWall
	end
	--print("self.Yraycastpoint2 : ",self.Yraycastpoint2)
	--print("self.Xraycastpoint2 :" ,self.Xraycastpoint2 )
end