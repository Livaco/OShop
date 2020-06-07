function OShop.Message(prefix, msg, notif, notiftime, prefixc, textc) // yikes
  if(notif == true) then
    notification.AddLegacy(msg, 0, notiftime)
    return
  else
    chat.AddText(prefixc, prefix, textc, " ", msg)
    return
  end
end

net.Receive("oshop_message", function() OShop.Message(net.ReadString(), net.ReadString(), net.ReadBool(), net.ReadInt(32), net.ReadColor(), net.ReadColor()) end)

net.Receive("oshop_openshop", function()
  local Config = net.ReadTable()
  local Categorys = net.ReadTable()
  local Items = net.ReadTable()

  local Theme = cookie.GetString("oshop_theme", Config[13].ConfigValue)
  OShop.Themes[Theme](Config, Categorys, Items)
end)