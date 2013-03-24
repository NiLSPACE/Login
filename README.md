Login
=====

Login is a security plugin for MCServer. It requires a player to log in before they can do any action on the server. This would be particuarly useful for servers that don't use the traditional Minecraft authentication.

Installation
------------

The installation for Login is simple, just follow these steps:

 * [Download Login](https://github.com/STRWarrior/Login/archive/master.zip)
 * Unzip the zip into your MCServer plugins folder.
 * In the plugins section of your `settings.ini` file, add the following line: `Plugin=Login`.
 * Add the following permissions to your default group in groups.ini:
   * login.register
   * login.login
   * login.changepass
   * login.logout
   * Add login.removeacc to your admin/mod group
 * You have now installed Login for MCServer!

Configuration
-------------

The configuration file for Login is located inside its folder in the Plugins folder. Simple edit `Config.Ini` and the configuration is at the top.
