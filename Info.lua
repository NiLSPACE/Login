
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "Login",
	Version = "2",
	Date = "2015-02-21",
	SourceLocation = "https://github.com/NiLSPACE/Login",
	Description = [[]],
	
	Commands =
	{
		['/login'] =
		{
			Permission = "login.login",
			HelpString = "Login into the server",
			Handler    = HandleLoginCommand,
		},
		
		['/register'] =
		{
			Permission = "login.register",
			HelpString = "Register an account =",
			Handler    = HandleRegisterCommand,
		},
	},
}