



cFileStorage = {}





function cFileStorage:__call()
	local Obj = {}
	
	setmetatable(Obj, cFileStorage)
	self.__index = self
	
	Obj.Passwords = {}
	
	local File = io.open(cRoot:Get():GetPluginManager():GetCurrentPlugin():GetLocalFolder() .. "/passwords.txt")
	if (not File) then
		File = io.open(cRoot:Get():GetPluginManager():GetCurrentPlugin():GetLocalFolder() .. "/passwords.txt", "w"):close()
	else
		for line in File:lines() do
			local Split = StringSplit(line, "=")
			Obj.Passwords[Split[1]] = Split[2]
		end
		File:close()
	end
	
	
	
	return Obj
end





function cFileStorage:GetPasswordFromUUID(a_UUID)
	return self.Passwords[a_UUID] or false
end





function cFileStorage:UpdatePassword(a_UUID, a_NewPassword)
	self.Obj.Passwords[a_UUID] = md5(a_NewPassword)
	return true
end





function cFileStorage:UUIDExists(a_UUID)
	return self.Obj.Passwords[a_UUID] ~= nil
end





setmetatable(cFileStorage, cFileStorage)
cFileStorage.__index = cFileStorage




