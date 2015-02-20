




cSQLiteStorage = {}





function cSQLiteStorage:__call()
	local Obj = {}
	
	setmetatable(Obj, cSQLiteStorage)
	self.__index = self
	
	Obj.m_DB = cSQLiteHandler(cRoot:Get():GetPluginManager():GetCurrentPlugin():GetLocalFolder() .. "/storage.sqlite")
	
	return Obj
end





function cSQLiteStorage:GetPasswordFromUUID(a_UUID)
	local res = self.m_DB:Select("players", "*", cWhereList():Where('uuid', a_UUID))
	
	if (not res) then
		return false, "Something went wrong in the database"
	end
	
	if (#res ~= 1) then
		return false, "There were multiple users with the same UUID"
	end
	
	return res[1]
end





function cSQLiteStorage:UpdatePassword(a_UUID, a_NewPassword)
	local whereList = cWhereList():Where('uuid', a_UUID)
	local res = self.m_DB:Select("players", "*", whereList)
	
	if (not res) then
		return false, "Something went wrong in the database"
	end
	
	if (#res ~= 1) then
		return false, "There were multiple users with the same UUID"
	end
	
	local updateList = cUpdateList:Update("password", a_NewPassword)
	local res = self.m_DB:Update("players", updateList, whereList)
	
	if (not res) then
		return false, "Something went wrong in the database"
	end
	
	return true
end





function cSQLiteStorage:UUIDExists(a_UUID)
	local res = self.m_DB:Select("players", "*", cWhereList():Where('uuid', a_UUID))
	
	if (not res) then
		return false, "Something went wrong in the database"
	end
	
	if (#res == 0) then
		-- The password does not yet exist
		return false
	end
	
	-- The password exists already
	return true
end






setmetatable(cSQLiteStorage, cSQLiteStorage)
cSQLiteStorage.__index = cSQLiteStorage





