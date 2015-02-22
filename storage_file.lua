



cFileStorage = {}





function cFileStorage:__call()
	local Obj = {}
	
	setmetatable(Obj, cFileStorage)
	self.__index = self
	
	Obj.m_Passwords = {}
	
	local File = io.open(cRoot:Get():GetPluginManager():GetCurrentPlugin():GetLocalFolder() .. "/passwords.txt")
	if (not File) then
		File = io.open(cRoot:Get():GetPluginManager():GetCurrentPlugin():GetLocalFolder() .. "/passwords.txt", "w"):close()
	else
		for line in File:lines() do
			local Split = StringSplit(line, "=")
			Obj.m_Passwords[Split[1]] = Split[2]
		end
		File:close()
	end
	
	return Obj
end





function cFileStorage:GetPasswordFromUUID(a_UUID)
	return self.m_Passwords[a_UUID] or false
end





function cFileStorage:RegisterOrChangePassword(a_UUID, a_NewPassword)
	self.m_Passwords[a_UUID] = cCryptoHash.md5HexString(a_NewPassword)
	return true
end





function cFileStorage:UUIDExists(a_UUID)
	return self.m_Passwords[a_UUID] ~= nil
end





function cFileStorage:Disable()
	local File = io.open(cRoot:Get():GetPluginManager():GetCurrentPlugin():GetLocalFolder() .. "/passwords.txt", "w")
	for UUID, Password in pairs(self.m_Passwords) do
		File:write("['", UUID, "'] = '", Password, "',\n")
	end
	File:close()
end





setmetatable(cFileStorage, cFileStorage)
cFileStorage.__index = cFileStorage




