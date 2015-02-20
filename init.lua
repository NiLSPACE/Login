




function Initialize(a_Plugin)
	a_Plugin:SetName("Login")
	a_Plugin:SetVersion(2)
	
	InitConfig()
	InitStorage()
	InitHooks()
	
	LOG("Login is initialized")
	return true
end