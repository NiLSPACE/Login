




-- Storage that contains all the passwords
g_PassStorage = nil





function InitStorage()
	local StorageType = g_Config.Storage:lower()
	
	if (StorageType == 'sqlite') then
		g_PassStorage = cSQLiteStorage()
	elseif (StorageType == 'file') then
		g_PassStorage = cFileStorage()
	end
	
	if (g_PassStorage == nil) then
		LOGWARNING("[Login] Unknown storage type. Using SQLite")
		g_PassStorage = cSQLiteStorage()
	end
end



