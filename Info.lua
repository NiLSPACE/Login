
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "Login",
	Version = "3",
	Date = "2015-12-29", -- yyyy-mm-dd
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
		
		['/removeacc'] =
		{
			Permission = "login.removeacc",
			HelpString = "Remove an account from the database",
			Handler    = HandleRemoveAccountCommand,
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
		
		["login.changepass"] =
		{
			Description = "Allows a player to change his password.",
			RecommendedGroups = "Default",
		},
		
		["login.removeacc"] =
		{
			Description = "Allows a player to remove an account",
			RecommendedGroups = "Admins",
		}
	},
	
	AdditionalInfo =
	{
		{
			Title = "Configuration",
			Contents = [[
If a configuration file doesn't exist yet Login will create one with the default settings.
Currently there are 2 things you can configurate
{%list}
	{%li} Storage: This can be "sqlite" (default). If choosen for sqlite the plugin will save everything in an sqlite database.
	
	{%li} LoginMessageTime: This is the time in ticks (50 msec) between an "You have to login" message.
{%/list}]],
		},
	},
}




