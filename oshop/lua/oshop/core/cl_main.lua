function OShop.Message(msg)
  if(OShop.Config.UseNotifications == true) then
    notification.AddLegacy(msg, 0, OShop.Config.NotificationTime)
    return
  else
    chat.AddText(OShop.Config.PrefixColor, OShop.Config.Prefix, OShop.Config.TextColor, " ", msg)
    return
  end
end

net.Receive("oshop_message", function() OShop.Message(net.ReadString()) end)

net.Receive("oshop_openshop", function()
  local Categorys = net.ReadTable()
  local Items = net.ReadTable()

  local Theme = cookie.GetString("oshop_theme", OShop.Config.VGUI.DefaultTheme)
  OShop.Themes[Theme](Categorys, Items)
end)