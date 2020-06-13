util.AddNetworkString("oshop_openshop")
util.AddNetworkString("oshop_message")
util.AddNetworkString("oshop_requestpurchuse")


OShop.Categorys = OShop.Categorys or {}
OShop.Items = OShop.Items or {}

function OShop.CreateCategory(name, table)
  OShop.Categorys[#OShop.Categorys + 1] = {
    name = name,
    desc = table.description,
    color = table.color
  }
end

function OShop.CreateItem(name, table)
  OShop.Items[#OShop.Items + 1] = {
    name = name,
    category = table.category,
    itemtype = table.itemtype,
    class = table.class,
    desc = table.description,
    color = table.color,
    price = table.price,
    needowning = table.setowning_ent,
    amount = table.amount
  }
end

function OShop.FindItemData(name)
  for k,v in pairs(OShop.Items) do
    if(v.name == name) then
      return v
    end
  end
end

function OShop.SVMessage(ply, msg)
  net.Start("oshop_message")
  net.WriteString(OShop.GetConfigValue("Prefix")[1].ConfigValue)
  net.WriteString(msg)
  net.WriteBool(tobool(OShop.GetConfigValue("UseNotifications")[1].ConfigValue))
  net.WriteInt(tonumber(OShop.GetConfigValue("NotificationTime")[1].ConfigValue), 32)
  local PColorTable = util.JSONToTable(OShop.GetConfigValue("PrefixColor")[1].ConfigValue)
  local PColor = Color(PColorTable.r, PColorTable.g, PColorTable.b, 255)
  net.WriteColor(PColor)
  local TColorTable = util.JSONToTable(OShop.GetConfigValue("TextColor")[1].ConfigValue)
  local TColor = Color(TColorTable.r, TColorTable.g, TColorTable.b, 255)
  net.WriteColor(TColor)
  net.Send(ply)
end

function OShop.CanUseCommands(ply)
  if(table.HasValue(util.JSONToTable(OShop.GetConfigValue("CommandGroups")[1].ConfigValue), ply:GetUserGroup())) then
    return true
  else
    return false
  end
end

function OShop.CreateTables()
  if(sql.TableExists("oshop_permaweapons") == false) then
    local Query = sql.Query("CREATE TABLE oshop_permaweapons(SteamID TEXT, Class TEXT);")
    if(Query == false) then
      OShop.Print("A error has occured while creating the table.")
      OShop.Print(string.format(OShop.Lang.SQLError, "CREATE TABLE oshop_permaweapons(SteamID TEXT, Class TEXT);"))
      return
    else
      OShop.Print(string.format(OShop.Lang.TableCreated, "oshop_permaweapons"))
    end
  end
end

function OShop.AddPermaWeapon(sid, class)
  -- Just incase the function at startup didn't work.

  OShop.CreateTables()
  local Query = sql.Query("INSERT INTO oshop_permaweapons(SteamID, Class) VALUES ('" .. sid .. "', '" .. class .. "');")
  if(Query == false) then
    OShop.Print(string.format(OShop.Lang.SQLError, "INSERT INTO oshop_permaweapons(SteamID, Class) VALUES ('" .. sid .. "', '" .. class .. "');"))
  else
    if(tobool(OShop.GetConfigValue("LogPerma")[1].ConfigValue) == true) then
      OShop.Print(string.format(OShop.Lang.PermaWeaponAssigned, sid, class))
    end
  end
end

function OShop.CheckPermaWeapon(sid)
  -- Just incase the function at startup didn't work.

  OShop.CreateTables()
  local Query = sql.Query("SELECT * FROM oshop_permaweapons WHERE '" .. sid .. "' = SteamID")
  if(Query == false) then
    OShop.Print(string.format(OShop.Lang.SQLError, "SELECT * FROM oshop_permaweapons WHERE '" .. sid .. "' = SteamID"))
  else
    return Query
  end
end

-- For permanent weapons
hook.Add("PlayerSpawn", "oshop_playerspawn", function(ply)
  local weapons = OShop.CheckPermaWeapon(ply:SteamID())
  if(weapons == nil) then return end
  for k,v in pairs(weapons) do
    ply:Give(v.Class, false)
  end
end)

net.Receive("oshop_requestpurchuse", function(len, ply)
  local Item = OShop.FindItemData(net.ReadString())
  if(ply:canAfford(Item.price) == false) then
    OShop.SVMessage(ply, OShop.Lang.CantAfford)
    return
  end
  if(Item.itemtype == "weapon") then
    ply:addMoney(Item.price * -1)
    ply:Give(Item.class)
    OShop.SVMessage(ply, string.format(OShop.Lang.BuyIt, string.Comma(Item.price)))
    return
  end

  if(Item.itemtype == "entity") then
    ply:addMoney(Item.price * -1)
    local ent = ents.Create(Item.class)
    ent:SetPos(ply:GetPos() + Vector(50, 0, 80))
    if(Item.needowning == true) then
      ent:Setowning_ent(ply)
    end
    ent:Spawn()
    
    -- TODO ownership should not be set here, a hook should be added 
    if zmlab then zmlab.f.SetOwner(ent, ply) end 

    OShop.SVMessage(ply, string.format(OShop.Lang.BuyIt, string.Comma(Item.price)))
    return
  end

  if(Item.itemtype == "ammo") then
    ply:addMoney(Item.price * -1)
    ply:GiveAmmo(Item.amount, Item.class)
    OShop.SVMessage(ply, string.format(OShop.Lang.BuyIt, string.Comma(Item.price)))
    return
  end

  if(Item.itemtype == "prop") then
    ply:addMoney(Item.price * -1)
    local ent = ents.Create("prop_physics")
    ent:SetPos(ply:GetPos() + Vector(50, 0, 80))
    ent:SetModel(Item.class)
    ent:Setowning_ent(ply)
    ent:Spawn()
    OShop.SVMessage(ply, string.format(OShop.Lang.BuyIt, string.Comma(Item.price)))
    return
  end

  if(Item.itemtype == "perm_weapon") then
    ply:addMoney(Item.price * -1)
    if(type(OShop.CheckPermaWeapon(ply:SteamID())) == "table") then
      for k,v in pairs(OShop.CheckPermaWeapon(ply:SteamID())) do
        if(v.Class == Item.class) then
          OShop.SVMessage(ply, OShop.Lang.AlreadyHasPerma)
          return
        end
      end
    end
    ply:Give(Item.class)
    OShop.AddPermaWeapon(ply:SteamID(), Item.class)
    OShop.SVMessage(ply, string.format(OShop.Lang.BuyIt, string.Comma(Item.price)))
    return
  end
  OShop.SVMessage(ply, OShop.Lang.NotBuyingIt)
end)

concommand.Add("oshop_clearallpermas", function(ply)
  if(not IsValid(ply)) then
    local Query = sql.Query("DELETE FROM oshop_permaweapons")
    if(Query == false) then
      OShop.Print(string.format(OShop.Lang.SQLError, "DELETE FROM oshop_permaweapons"))
    else
      OShop.Print(OShop.Lang.PermaWeaponClear)
    end
  else
    if(OShop.CanUseCommands(ply) == true) then
      local Query = sql.Query("DELETE FROM oshop_permaweapons")
      if(Query == false) then
        OShop.SVMessage(ply, "There was an error clearing all permanant weapons (Query returned false). SQL: DELETE FROM oshop_permaweapons")
        OShop.SVMessage(ply, "Send this error in a support ticket!")
        OShop.Print(ply, ply:Nick() .. " attempted to clear all perma weapons.")
      else
        OShop.SVMessage(ply, "Successfully cleared! Note that players that have perma weapons will need to respawn to get rid of them!")
        OShop.Print(ply:Nick() .. " cleared all perma weapons.")
      end
    else
      OShop.SVMessage(ply, "You do not have access to that!")
      return
    end
  end
end)

function OShop.FindPlyByName(name)
  for k,v in pairs(player.GetAll()) do
    if(v:Nick() == name) then
      return v
    end
  end
end

concommand.Add("oshop_unbindweapon", function(ply, _, args)
  if(not IsValid(ply)) then
    if(args[1] == nil or args[1] == "") then
      OShop.Print("No player specified!")
      return
    end
    if(args[2] == nil or args[2] == "") then
      OShop.Print("No weapon class specified!")
      return
    end
    local target = OShop.FindPlyByName(args[1])
    if(not IsValid(target)) then
      OShop.Print("Could not find player!")
      return
    end
    local Query = sql.Query("DELETE FROM oshop_permaweapons WHERE SteamID = '" .. target:SteamID() .. "' AND Class = '" .. args[2] .."';")
    if(Query == false) then
      OShop.Print("There was an error clearing that users permanant weapon (Query returned false). SQL: DELETE FROM oshop_permaweapons WHERE SteamID = '" .. target:SteamID() .. "' AND Class = '" .. args[2] .."';")
      OShop.Print("Send this error in a support ticket!")
    else
      OShop.Print("Successfully cleared that weapon from the player.")
    end
  else
    if(OShop.CanUseCommands(ply) == true) then
      if(args[1] == nil or args[1] == "") then
        OShop.SVMessage(ply, "No player specified!")
        return
      end
      if(args[2] == nil or args[2] == "") then
        OShop.SVMessage(ply, "No weapon class specified!")
        return
      end
      local target = OShop.FindPlyByName(args[1])
      if(not IsValid(target)) then
        OShop.SVMessage(ply, "Could not find player!")
        return
      end
      local Query = sql.Query("DELETE FROM oshop_permaweapons WHERE SteamID = '" .. target:SteamID() .. "' AND Class = '" .. args[2] .."';")
      if(Query == false) then
        OShop.SVMessage(ply, "There was an error clearing that users permanant weapon (Query returned false). SQL: DELETE FROM oshop_permaweapons WHERE SteamID = '" .. target:SteamID() .. "' AND Class = '" .. args[2] .."';")
        OShop.SVMessage(ply, "Send this error in a support ticket!")
      else
        OShop.SVMessage(ply, "Successfully cleared that weapon from the player.")
      end
    else
      OShop.SVMessage(ply, "You do not have access to that!")
      return
    end
  end
end)

concommand.Add("oshop_assignweapon", function(ply, _, args)
  if(not IsValid(ply)) then
    if(args[1] == nil or args[1] == "") then
      OShop.Print("No player specified!")
      return
    end
    if(args[2] == nil or args[2] == "") then
      OShop.Print("No weapon class specified!")
      return
    end
    local target = OShop.FindPlyByName(args[1])
    if(not IsValid(target)) then
      OShop.Print("Could not find player!")
      return
    end
    OShop.AddPermaWeapon(target:SteamID(), args[2])
    OShop.SVMessage(ply, "That weapon has been assigned to the player!")
  else
    if(OShop.CanUseCommands(ply) == true) then
      if(args[1] == nil or args[1] == "") then
        OShop.SVMessage(ply, "No player specified!")
        return
      end
      if(args[2] == nil or args[2] == "") then
        OShop.SVMessage(ply, "No weapon class specified!")
        return
      end
      local target = OShop.FindPlyByName(args[1])
      if(not IsValid(target)) then
        OShop.SVMessage(ply, "Could not find player!")
        return
      end
      OShop.AddPermaWeapon(target:SteamID(), args[2])
      OShop.SVMessage(ply, "That weapon has been assigned to the player!")
    else
      OShop.SVMessage(ply, "You do not have access to that!")
      return
    end
  end
end)
