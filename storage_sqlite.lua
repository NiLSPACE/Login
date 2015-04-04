




cSQLiteStorage = {}





function cSQLiteStorage:__call()
	local Obj = {}
	
	setmetatable(Obj, cSQLiteStorage)
	self.__index = self
	
	local Table = cTable("players")
	:Field("uuid", "TEXT")
	:Field("password", "TEXT")
	
	Obj.m_DB = cSQLiteHandler(cRoot:Get():GetPluginManager():GetCurrentPlugin():GetLocalFolder() .. "/storage.sqlite", Table)
	
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
	
	return res[1]['password']
end





function cSQLiteStorage:RegisterOrChangePassword(a_UUID, a_Password)
	local whereList = cWhereList():Where('uuid', a_UUID)
	local res = self.m_DB:Select("players", "*", whereList)
	
	if (not res) then
		return false, "Something went wrong in the database"
	end
	
	-- The password doesn't exist yet. We insert it instead
	if (#res == 0) then	
		local insertList = cInsertList()
		:Insert('uuid', a_UUID)
		:Insert('password', cCryptoHash.md5HexString(a_Password))
		
		-- Insert the password
		self.m_DB:Insert("players", insertList)
		return true
	end
	
	
	if (#res ~= 1) then
		-- WEIRD there are multiple users with the same UUID.
		return false, "There were multiple users with the same UUID"
	end
	
	local updateList = cUpdateList():Update("password", cCryptoHash.md5HexString(a_Password))
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





function cSQLiteStorage:DeleteUUID(a_UUID)
	local res = self.m_DB:Delete("players", cWhereList():Where("uuid", a_UUID))
	
	if (not res) then
		return false, "Something went wrong in the database"
	end
	
	return true
end





function cSQLiteStorage:Disable()
	-- cSQLiteStorage doesn't have to save the passwords when disabling.
end






setmetatable(cSQLiteStorage, cSQLiteStorage)
cSQLiteStorage.__index = cSQLiteStorage





