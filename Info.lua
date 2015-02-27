
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "Login",
	Version = "2",
	Date = "2015-02-21",
	SourceLocation = "https://github.com/NiLSPACE/Login",
	Description = [[
Login is a security plugin for MCServer. 
It requires a player to log in before they can do any action on the server. 
This way people can't login on the account of an admin or moderator.
This would be particuarly useful for servers that don't use the traditional Minecraft authentication.]],
	
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
			HelpString = "Register an account",
			Handler    = HandleRegisterCommand,
		},
		
		['/changepass'] =
		{
			Alias      = {"/updatepass"},
			Permission = "login.changepass",
			HelpString = "Change your password",
			Handler    = HandleChangePassCommand,
		},
	},
	
	Permissions =
	{
		["login.login"] =
		{
			Description = "Allows a player to log in",
			RecommendedGroups = "Default",
		},
		
		["login.register"] =
		{
			Description = "Allows a player to create an account for himself.",
			RecommendedGroups = "Default",
		},
		
		["login.changepass"]=
		{
			Description = "Allows a player to change his password.",
			RecommendedGroups = "Default",
		},
	},
	
	AdditionalInfo =
	{
		{
			Title = "Configuration",
			Contents = [[
If a configuration file doesn't exist yet Login will create one with the default settings.
Currently there are 2 or 3 things you can configurate depending on the password storage you choose.{%p}
{%list}
	{%li} Storage: This can be "sqlite" (default) or "file". If choosen for file then the plugin will save all the passwords in a file, and if choosen for sqlite the plugin will save everything in an sqlite database.{%p}
	{%li} LoginMessageTime: This is the time in ticks (50 msec) between an "You have to login" message.{%p}
	
	If the storage is set to file then you can also change the compression of the password file.{%p}
	{%li} CompressionLevel: A number where 0 is no compression and 9 is maximum compression.{%p}
{%/list}]],
		},
	},
}




