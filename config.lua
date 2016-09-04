




g_ConfigDefaults = [[ 
Storage          = "sqlite",
LoginMessageTime = 50,

NetworkAPI = 
{
	Enabled = false,
	Secret = '',
	Port = 8888
}
]]



function InitConfig()
	local Path = cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/config.cfg"
	if (not cFile:IsFile(Path)) then
		LOGWARNING("[Login] The config file doesn't exist. Login will write and load the default settings for now")
		WriteDefaultSettings(Path)
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
	
	if (ConfigTable.NetworkAPI and ConfigTable.NetworkAPI.Enabled) then
		if (ConfigTable.NetworkAPI.Secret:len() < 10) then
			LOGWARNING("[Login] The NetworkAPI is enabled, but your Secret is too short. Please provide a more secure secret.")
			LOGWARNING("[Login] The network API is disabled.")
			ConfigTable.NetworkAPI.Enabled = false
		end
	end
	
	-- prevent errors with older configuration files
	ConfigTable.NetworkAPI = ConfigTable.NetworkAPI or {}
	
	g_Config = ConfigTable
end





function LoadDefaultSettings()
	g_Config = loadstring("return {" .. g_ConfigDefaults .. "}")()
end




function WriteDefaultSettings(a_Path)
	local File = io.open(a_Path, "w")
	File:write(g_ConfigDefaults)
	File:close()
end




