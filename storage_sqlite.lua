
-- Implements the cSQLiteStorage class





-- Load all the queries
local g_Queries = {}
local Path = cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/Queries"
for _, FileName in ipairs(cFile:GetFolderContents(Path)) do
	if (FileName:match("%.sql$")) then
		g_Queries[FileName:match("^(.*)%.sql$")] = cFile:ReadWholeFile(Path .. "/" .. FileName)
	end
end





cSQLiteStorage = {}





function cSQLiteStorage:new()
	local Obj = {}
	
	setmetatable(Obj, cSQLiteStorage)
	self.__index = self
	
	local ErrorCode, ErrorMsg;
	Obj.DB, ErrorCode, ErrorMsg = sqlite3.open(cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/storage.sqlite")
	if (Obj.DB == nil) then
		LOGWARNING("Database could not be opened. Aborting");
		error(ErrMsg);  -- Abort the plugin
	end
	
	-- Initialize the database
	Obj:ExecuteCommand("initialize")
	
	return Obj
end





--- Executes a query that was loaded before.
-- The parameters is a dictionary. The key is the name of the parameter. 
-- This can be found with a $ or : in front of it in the actual query.
-- If a callback is given it calls that for each row where the parameter is a dictionary
-- Returns true on success, while it returns false with the error message when failing
function cSQLiteStorage:ExecuteCommand(a_QueryName, a_Parameters, a_Callback)
	local Command = assert(g_Queries[a_QueryName], "Requested Query doesn't exist")
	local Stmt, ErrCode, ErrMsg = self.DB:prepare(Command)
	if (not Stmt) then
		LOGWARNING("Cannot prepare query \"" .. a_QueryName .. "\": " .. (ErrCode or "<unknown>") .. " (" .. (ErrMsg or "<no message>") .. ")")
		return false, ErrorMsg or "<no message>"
	end
	
	if (a_Parameters ~= nil) then
		Stmt:bind_names(a_Parameters)
	end
	
	if (a_Callback ~= nil) then
		for val in Stmt:nrows() do
			if (a_Callback(val)) then
				break
			end
		end
	else
		Stmt:step()
	end
	
	Stmt:finalize()
	return true
end





-- Finds the UUID in the database and returns its password 
function cSQLiteStorage:GetPasswordFromUUID(a_UUID)
	local Password;
	local Success, ErrorMsg = self:ExecuteCommand("get_password",
		{
			uuid = a_UUID
		},
		function(a_Values)
			Password = a_Values["password"]
			return true
		end
	)
	
	if (not Success) then
		return false, ErrorMsg
	end
	
	if (not Password) then
		return false, "The player does not exist"
	end
	
	return Password
end





-- Registers a username. It the user already exists it updates the password.
function cSQLiteStorage:RegisterOrChangePassword(a_UUID, a_Password)
	local Success, ErrorMsg = self:ExecuteCommand("update_password", 
		{
			uuid = a_UUID, 
			password = cCryptoHash.md5HexString(a_Password)
		}
	)
	
	if (not Success) then
		return false, ErrorMsg
	end
	
	return true
end





-- Checks if a UUID is known in the database
function cSQLiteStorage:UUIDExists(a_UUID)
	local Pwd, ErrorMsg = self:GetPasswordFromUUID(a_UUID)
	if (type(Pwd) == "string") then
		return true
	end
	
	return false, ErrorMsg
end





-- Removes a UUID from the database
function cSQLiteStorage:DeleteUUID(a_UUID)
	local Success, ErrorMsg = self:ExecuteCommand("remove_account",
		{
			uuid = a_UUID
		}
	)
	
	if (not Success) then
		return false, ErrorMsg
	end
	
	return true
end





function cSQLiteStorage:Disable()
	-- cSQLiteStorage doesn't have to save the passwords when disabling.
end




