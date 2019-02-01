OShop = {}

function OShop.Print(msg)
  if CLIENT then
    MsgC(Color(255, 255, 255), "[")
    MsgC(Color(255, 0, 0), "OShop")
    MsgC(Color(255, 255, 255), "] ")
    MsgC(Color(255, 255, 255), msg)
    MsgC(Color(255, 255, 255), "\n")
  else
    MsgC(Color(255, 255, 255), "[")
    MsgC(Color(255, 150, 150), "OShop")
    MsgC(Color(255, 255, 255), "] ")
    MsgC(Color(255, 255, 255), msg)
    MsgC(Color(255, 255, 255), "\n")
  end
end

OShop.Config = OShop.Config or {}
OShop.Config.NPC = OShop.Config.NPC or {}
OShop.Config.VGUI = OShop.Config.VGUI or {}
OShop.Config.Buy = OShop.Config.Buy or {}
OShop.Lang = OShop.Lang or {}

AddCSLuaFile("oshop/config/config.lua")
AddCSLuaFile("oshop/config/lang.lua")
if SERVER then
  OShop.Print("Loading serverside...")

  include("oshop/core/sv_main.lua") OShop.Print("sv_main.lua")
  OShop.CreateTables()

  OShop.Print("Loading default categorys and items.")
  for b, File in SortedPairs(file.Find("oshop/items/*.lua", "LUA"), true) do
    OShop.Print("Loading file: " .. File)
    include("oshop/items/" .. File)
  end

  AddCSLuaFile("oshop/core/cl_main.lua") // AddCSLuaFile are not logged.
  AddCSLuaFile("oshop/core/themes/themes.lua")

  OShop.Print("Loaded.")
else
  OShop.Print("Loading clientside...")

  include("oshop/core/themes/themes.lua") OShop.Print("themes.lua")
  include("oshop/core/cl_main.lua") OShop.Print("cl_main.lua")

  OShop.Print("Loaded.")
end