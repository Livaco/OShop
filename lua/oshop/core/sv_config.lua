// THIS IS NOT THE CONFIG. USE !oshop_config IN-GAME TO ACCESS IT. IF YOU CANNOT ACCESS IT, GOTO oshop/config/config.lua AND EDIT THE FIRST TABLE. FIRST!

util.AddNetworkString("oshop_openconfig")
util.AddNetworkString("oshop_changeconfig")

OShop.DefaultConfig = {
  // General

  UseNotifications = {
    Type = "Bool",
    Name = "Use Notifications",
    Category = "General",
    Desc = "If true, the addon will use Notifications instead of chat messages.",
    Value = false
  },

  NotificationTime = {
    Type = "Int",
    Name = "Notification Popup Time",
    Category = "General",
    Desc = "How long should notifications show up if they are enabled?",
    Value = 5
  },

  Prefix = {
    Type = "String",
    Name = "Chat Prefix",
    Category = "General",
    Desc = "If you are not using notifications, what will the Prefix be.",
    Value = "[OShop]"
  },

  PrefixColor = {
    Type = "Color",
    Name = "Chat Prefix Color",
    Category = "General",
    Desc = "If you are not using notifications, what will the color of the Prefix be.",
    Value = {
      r = 200,
      g = 0,
      b = 0
    }
  },

  TextColor = {
    Type = "Color",
    Name = "Text Color",
    Category = "General",
    Desc = "If you are not using notifications, what color will the rest of the text be.",
    Value = {
      r = 255,
      g = 255,
      b = 255
    }
  },

  Font = {
    Type = "String",
    Name = "Font",
    Category = "General",
    Desc = "The font the addon uses through out the VGUIs. Make sure its installed properly on the server.",
    Value = "Roboto"
  },

  CommandGroups = {
    Type = "Table",
    Name = "Console Command Groups",
    Category = "General",
    Desc = "Usergroups that can use Console Commands. Use JSON.",
    Value = {"superadmin", "admin"}
  },

  LogPerma = {
    Type = "Bool",
    Name = "Log permanent Purchases",
    Category = "General",
    Desc = "If true, the addon will print into the server console when a player is given a permanent weapon.",
    Value = true
  },

  // NPC
  NPCModel = {
    Type = "String",
    Name = "NPC Model",
    Category = "NPC",
    Desc = "The model of the NPC",
    Value = "models/Humans/Group03/male_06.mdl"
  },

  NPC3D2D = {
    Type = "String",
    Name = "NPC 3D2D",
    Category = "NPC",
    Desc = "The text for the 3D2D.",
    Value = "Omega Shop"
  },

  NPC3D2DFollow = {
    Type = "Bool",
    Name = "3D2D Stare",
    Category = "NPC",
    Desc = "If false, the NPC 3D2D will stay at a static angle, else it will look at the player.",
    Value = true
  },

  // VGUI
  VGUITheme = {
    Type = "String",
    Name = "Default VGUI Theme",
    Category = "VGUI",
    Desc = "The default theme the Derma should use. You can use Solid, Blur or Opacity.",
    Value = "Solid"
  },

  VGUITitle = {
    Type = "String",
    Name = "VGUI Title",
    Category = "VGUI",
    Desc = "The title for the Shop VGUI",
    Value = "Omega Shop"
  },

  VGUICloseOnBuy = {
    Type = "Bool",
    Name = "Close frame on buy",
    Category = "VGUI",
    Desc = "If the VGUI should close on buy",
    Value = false
  }
}
// Fuck me thats a long table

function OShop.ConfigChecks()
  OShop.Print("Running config checks.")
  if(!sql.TableExists("oshop_config")) then
    OShop.Print("Table does not exist! Creating...")
    local TableQuery = sql.Query("CREATE TABLE oshop_config(ConfigKey TEXT, Type TEXT, Name TEXT, Category TEXT, Description TEXT, ConfigValue TEXT);")
    if(TableQuery == false) then
      OShop.Print("SQL Failed! (Query Returned False). Send this in a Support Ticket.")
      OShop.Print("SQL: CREATE TABLE oshop_config(ConfigKey TEXT, Type TEXT, Name TEXT, Category TEXT, Description TEXT, ConfigValue TEXT);")
      print("")
      OShop.Print("Not continuing with config creation.")
      return
    else
      OShop.Print("Table created. Inserting rows...")
      for k,v in pairs(OShop.DefaultConfig) do
        local Value
        if(type(v.Value) == "table") then
          Value = util.TableToJSON(v.Value)
        else
          Value = v.Value
        end
        local sql = sql.Query("INSERT INTO oshop_config(ConfigKey, Type, Name, Category, Description, ConfigValue) VALUES('"..k.."', '"..v.Type.."', '"..v.Name.."', '"..v.Category.."', '"..v.Desc.."', '"..tostring(Value).."');")
        if(sql == false) then
          OShop.Print("SQL Failed! (Query Returned False), for config option " .. k .. ". Send this in a Support Ticket.")
          OShop.Print("SQL: INSERT INTO oshop_config(ConfigKey, Type, Name, Category, Description, ConfigValue) VALUES('"..k.."', '"..v.Type.."', '"..v.Name.."', '"..v.Category.."', '"..v.Desc.."', '"..tostring(Value).."');")
          print("")
          OShop.Print("Not continuing with config creation.")
          return
        else
          OShop.Print("Inserted config value " .. k)
        end
      end
    end
    OShop.Print("Table Created with rows inputted.")
  else
    OShop.Print("Table exists. Not taking any further action.")
  end
end

function OShop.GetConfigValue(key)
  local Query = sql.Query("SELECT * FROM oshop_config WHERE ConfigKey = '"..key.."'")
  if(Query == false) then
    OShop.Print("SQL Failed! (Query Returned False), while getting config key " .. key .. ". Send this in a Support Ticket.")
    OShop.Print("SQL: SELECT * FROM oshop_config WHERE ConfigKey = '"..key.."'")
    print("")
    OShop.Print("Not continuing with selecting config value.")
  else
    return Query
  end
end

function OShop.GetConfig()
  local Query = sql.Query("SELECT * FROM oshop_config")
  if(Query == false) then
    OShop.Print("SQL Failed! (Query Returned False), while getting config. Send this in a Support Ticket.")
    OShop.Print("SELECT * FROM oshop_config")
    print("")
    OShop.Print("Not continuing with selecting config.")
  else
    return Query
  end
end

function OShop.ChangeConfigValue(key, newvalue)
  local Query = sql.Query("UPDATE oshop_config SET ConfigValue = '"..newvalue.."' WHERE ConfigKey = '"..key.."'")
  if(Query == false) then
    OShop.Print("SQL Failed! (Query Returned False), while updating config key " .. key .. ". Send this in a Support Ticket.")
    OShop.Print("SQL: UPDATE oshop_config SET ConfigValue = '"..newvalue.."' WHERE ConfigKey = '"..key.."'")
    print("")
    OShop.Print("Not continuing with updating config value.")
  end
end

hook.Add("PlayerSay", "oshop_commands", function(ply, text, team)
  local lower = string.lower(text)
  if(string.sub(text, 1, 13) == "!oshop_config") then
    if(table.HasValue(OShop.Config.InGameConfigGroups, ply:GetUserGroup())) then
      net.Start("oshop_openconfig")
      net.WriteTable(OShop.GetConfig())
      net.Send(ply)
      OShop.SVMessage(ply, OShop.Lang.OpenConfig)
      return
    else
      OShop.SVMessage(ply, OShop.Lang.NoAccess)
      return
    end
  end
end)

net.Receive("oshop_changeconfig", function(len, ply)
  if(table.HasValue(OShop.Config.InGameConfigGroups, ply:GetUserGroup())) then
    local Key = net.ReadString()
    local Type = net.ReadString()
    if(Type == "String") then
       OShop.ChangeConfigValue(Key, net.ReadString())
    end
    if(Type == "Bool") then
       OShop.ChangeConfigValue(Key, tostring(net.ReadBool()))
    end
    if(Type == "Color") then
       OShop.ChangeConfigValue(Key, util.TableToJSON(net.ReadColor()))
    end
    if(Type == "Table") then
       OShop.ChangeConfigValue(Key, net.ReadString()) // Uses JSON so there's no converting or anything... for now...
    end
    if(Type == "Int") then
       OShop.ChangeConfigValue(Key, tostring(net.ReadInt(32)))
    end
    OShop.SVMessage(ply, OShop.Lang.ConfigUpdate)
    return
  else
    OShop.SVMessage(ply, OShop.Lang.NoAccess)
    return
  end
end)