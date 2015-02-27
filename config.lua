




g_ConfigDefaults = 
{
	Storage          = "sqlite",
	LoginMessageTime = 50,
}




function InitConfig()
	local Path = cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/config.cfg"
	if (not cFile:Exists(Path)) then
		LOGWARNING("[Login] The config file doesn't exist. Login will use the default settings for now")
		LoadDefaultSettings()
		return
	end
	
	local ConfigContent = cFile:ReadWholeFile(Path)
	if (ConfigContent == "") then
		LOGWARNING("[Login] The config file is empty. Login will use the default settings for now")
		LoadDefaultSettings()
		return
	end
	
	local ConfigLoader, Error  = loadstring("return {" .. ConfigContent .. "}")
	if (not ConfigLoader) then
		LOGWARNING("[Login] There is a problem in the config file. Login will use the default settings for now.")
		LoadDefaultSettings()
		return
	end
	
	local Result, ConfigTable, Error = pcall(ConfigLoader)
	if (not Result) then
		LOGWARNING("[Login] There is a problem in the config file. Login will use the default settings for now.")
		LoadDefaultSettings()
		return
	end
	
	if (type(ConfigTable.Storage) ~= 'string') then
		LOGWARNING("[Login] Invalid storage type configurated. Login will use SQLite")
		ConfigTable.Storage = 'sqlite'
	end
	
	if (ConfigTable.Storage == "file") then
		if ((type(ConfigTable.CompressionLevel) ~= 'number') and (not tonumber(ConfigTable.CompressionLevel))) then
			LOGWARNING("[Login] Invalid compression level.")
			ConfigTable.CompressionLevel = 5
		end
		
		ConfigTable.CompressionLevel = tonumber(ConfigTable.CompressionLevel)
	end
	
	if (type(ConfigTable.LoginMessageTime) ~= 'number') then
		if (type(ConfigTable.LoginMessageTime) == 'string') then
			local Time = tonumber(ConfigTable.LoginMessageTime)
			if (not Time) then
				LOGWARNING("[Login] Invalid login message time. Default will be used.")
				ConfigTable.LoginMessageTime = g_ConfigDefaults.LoginMessageTime
			else
				ConfigTable.LoginMessageTime = Time
			end
		else
			LOGWARNING("[Login] Invalid login message time. Default will be used.")
			ConfigTable.LoginMessageTime = g_ConfigDefaults.LoginMessageTime
		end
	end
			
	
	g_Config = ConfigTable
end





function LoadDefaultSettings()
	g_Config = g_ConfigDefaults
end



