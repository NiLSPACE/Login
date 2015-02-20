



cFileStorage = {}





function cFileStorage:__call()
	local Obj = {}
	setmetatable(Obj, cFileStorage)
	self.__index = self
	
	return Obj
end




setmetatable(cFileStorage, cFileStorage)
cFileStorage.__index = cFileStorage




