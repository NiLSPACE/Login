-- Author STR_Warrior --

function LoadSettings()
  Settings = cIniFile(PLUGIN:GetLocalDirectory() .."/Config.ini")
	Settings:ReadFile()
	Tries = 						Settings:GetValueSetI("Settings","Tries", 			3)
	Storage = 						Settings:GetValueSet("Settings", "Storage", "Ini")
									Settings:KeyComment("Settings", 'There are 2 storage types. the "Old" and the new "Ini" ')
	NotRegistered = 				Settings:GetValueSet("Messages","NotRegistered", 	"Please register using /register (password)")
	NotLoggedIn = 					Settings:GetValueSet("Messages","NotLoggedIn", 	"Please log in using /login (password)")
	TossingItem = 					Settings:GetValueSet("Messages","TossingItem", 	"Please log in before tossing items")
	OnPlayerChat = 					Settings:GetValueSet("Messages","OnPlayerChat", 	"Please log in before you start talking")
	OnBreaking =					Settings:GetValueSet("Messages","PlayerBreaking","Please log in before breaking blocks")
	OnPlacing = 					Settings:GetValueSet("Messages","PlayerPlacing", 	"Please log in before placing blocks")
	ChangePasswordWrong = 			Settings:GetValueSet("Messages","ChangePasswordWrong","your old password is wrong. Usage: /changepass (oldpassword) (newpassword)")
	ChangePassword = 				Settings:GetValueSet("Messages","ChangePassword", 	"Usage: /changepass (oldpassword) (newpassword)")
	LoggedIn = 						Settings:GetValueSet("Messages","LoggedIn", 		"You are logged in")
	Login = 						Settings:GetValueSet("Messages","Login","Usage: /login (password)")
	AlreadyLoggedIn = 				Settings:GetValueSet("Messages","AlreadyLoggedIn" ,"You are already logged in")
	Logout = 						Settings:GetValueSet("Messages","Logout","You are now logged out")
	Register = 						Settings:GetValueSet("Messages","Register","Usage: /register (password)")
	AlreadyRegistered = 			Settings:GetValueSet("Messages","AlreadyRegistered","you already have registered")
	Registered = 					Settings:GetValueSet("Messages","Registered","You have registered")
	RemoveAcc = 					Settings:GetValueSet("Messages","RemoveAcc","Usage: /removeacc (player)")
	DeleteNoAccount = 				Settings:GetValueSet("Messages","NoDeleteAccount","Acount does not exist")
	AccountRemoved = 				Settings:GetValueSet("Messages","AccountRemoved","Account Removed")
	ReloadKick = 					Settings:GetValueSet("Kick","Reload","The server was reloaded while you were not logged in.")
	Settings:WriteFile()
end

function LoadOnlinePlayers()
    local loopPlayers = function( Player )
		Auth[Player:GetName()] = true
    end
    local loopWorlds = function ( World )
        World:ForEachPlayer( loopPlayers )
    end
    cRoot:Get():ForEachWorld( loopWorlds )
end

function LoadPasswords()
	PassIni = cIniFile(PLUGIN:GetLocalDirectory() .. "/Players.ini")
	PassIni:ReadFile()
	PassIni:WriteFile()
end
