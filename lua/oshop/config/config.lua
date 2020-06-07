// THIS IS THE ONLY VALUE YOU SHOULD CHANGE.
// This defines what usergroups are allowed to use the in-game config. This is defined in a file for security reasons, and cannot be changed in-game.
OShop.Config.InGameConfigGroups = {"superadmin", "admin"}

// If you are having issues with the config being invalid, run THIS console command and restart your server: lua_run sql.Query("DROP TABLE oshop_config")
// What this does is simple delete the SQLite table that has the config inside it, allowing the addon to attempt to recreate it on server restart.



--[[



----------------------------------------
DON'T GODDAMN USE THE REST OF THIS FILE
USE THE INGAME CONFIG WITH !oshop_config
YOU SHOULD ONLY EDIT THE FIRST VALUE OF THIS FILE AND THE LANGUAGE FILE AT LANG.LUA
YOU HAVE BEEN WARNED
----------------------------------------



]]--





















/*
OShop by Livaco
Configuration
If you need help, goto livaco.tk and make a support ticket.
*/

/*
General Settings
*/

// Setting this to true means the addon uses Notifcations for messages instead of chat. Recomended to keep this false.
OShop.Config.UseNotifications = false

// If above is true, how long to keep the notification on-screen in seconds.
OShop.Config.NotificationTime = 5

// If you are not using notifications, what Prefix will the addon use.
OShop.Config.Prefix = "[OShop]"

// If you are not using notifications, what color will the Prefix be.
OShop.Config.PrefixColor = Color(200, 0, 0)

// If you are not using notifications, what color will the rest of the text be.
OShop.Config.TextColor = Color(255, 255, 255)

// The font to use throughout the addon. Make sure it's installed properly on the server.
OShop.Config.Font = "Roboto"

// Groups that can use the Console Commands.
OShop.Config.CommandGroups = {
  "superadmin",
  "admin"
}

/*
NPC Settings
*/

// The model of the NPC.
OShop.Config.NPC.Model = "models/Humans/Group03/male_06.mdl"

// The text for the box above the NPC.
OShop.Config.NPC.Text = "Omega Shop"

// If the 3D2D should look at the player or stay in a static angle.
OShop.Config.NPC.Follow = true

/*
VGUI Settings
*/

// The default theme the Derma should use. You can use Solid, Blur or Opacity.
OShop.Config.VGUI.DefaultTheme = "Solid"

// The title of the panel.
OShop.Config.VGUI.Title = "Omega Shop"

// If the VGUI should close if the player attempts to buy something.
OShop.Config.VGUI.CloseOnBuy = true

/*
Buying Settings
*/

// If the addon should log when a player buys a perma-weapon in the console (server console only). Also note that if this is false, if you assing a weapon in the console it will not print it.
OShop.Config.Buy.LogPerma = true