OShop.Themes = OShop.Themes or {}

OShop.Themes["Solid"] = function(Config, Categorys, Items)
  surface.CreateFont("oshop_vgui1", {
    font = Config[10].ConfigValue,
    size = ScrH() * 0.03
  })

  surface.CreateFont("oshop_vgui2", {
    font = Config[10].ConfigValue,
    size = ScrH() * 0.05
  })

  surface.CreateFont("oshop_vgui3", {
    font = Config[10].ConfigValue,
    size = ScrH() * 0.02
  })

  local frame = vgui.Create("DFrame")
  frame:SetSize(ScrW() * 0.6, ScrH() * 0.6)
  frame:SetTitle("")
  frame:SetDraggable(false)
  frame:ShowCloseButton(false)
  frame:Center()
  frame:MakePopup()
  frame.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 255))
    draw.RoundedBox(0, 0, 0, w, h * 0.05, Color(0, 0, 0, 255))
    draw.SimpleText(Config[3].ConfigValue, "oshop_vgui1", w * 0.005, 0, Color(255, 255, 255), 0, 0)
  end

  local w,h = frame:GetWide(), frame:GetTall()

  local Close = vgui.Create("DButton", frame)
  Close:SetPos(w * 0.971, 0)
  Close:SetSize(w * 0.03, h * 0.05)
  Close:SetText("")
  Close.Paint = function(s, w, h)
    if(s:IsHovered() == true) then
      draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
    else
      draw.RoundedBox(0, 0, 0, w, h, Color(200, 0, 0, 255))
    end
    draw.SimpleText("X", "oshop_vgui1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
  end
  Close.DoClick = function()
    frame:Close()
  end

  local ThemeSelect = vgui.Create("DComboBox", frame)
  ThemeSelect:SetPos(w * 0.02, h * 0.925)
  ThemeSelect:SetSize(w * 0.25, h * 0.04)
  ThemeSelect:SetValue("Theme Select")
  ThemeSelect:AddChoice("Solid")
  ThemeSelect:AddChoice("Blur")
  ThemeSelect:AddChoice("Opacity")
  ThemeSelect.OnSelect = function(a, b, value)
    cookie.Set("oshop_theme", value)
    frame:Close()
    local PrefixCC = util.JSONToTable(Config[4].ConfigValue)
    local PrefixC = Color(PrefixCC.r, PrefixCC.g, PrefixCC.b, 255)
    local TextCC = util.JSONToTable(Config[11].ConfigValue)
    local TextC = Color(TextCC.r, TextCC.g, TextCC.b, 255)
    OShop.Message(Config[5].ConfigValue, string.format(OShop.Lang.ChangeTheme, value), tobool(Config[8].ConfigValue), tonumber(Config[14].ConfigValue), PrefixC, TextC)
  end

  local SelectedCategory = ""
  local CategoryPanel = vgui.Create("DScrollPanel", frame)
  CategoryPanel:SetSize(w * 0.25, h * 0.825)
  CategoryPanel:SetPos(w * 0.02, h * 0.075)
  CategoryPanel.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
  end

  local bar = CategoryPanel:GetVBar()
  function bar:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
  end
  function bar.btnUp:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnDown:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnGrip:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
  end

  local ItemPanel = vgui.Create("DScrollPanel", frame)
  ItemPanel:SetSize(w * 0.68, h * 0.89)
  ItemPanel:SetPos(w * 0.3, h * 0.075)
  ItemPanel.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
  end
  local bar = ItemPanel:GetVBar()
  function bar:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
  end
  function bar.btnUp:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnDown:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnGrip:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
  end

  local ItemY = 0
  local ItemNum = 0
  local function RebuildItems()
    ItemPanel:Clear()
    ItemY = 0
    ItemNum = 0
    for k,v in ipairs(Items) do
      if(v.category == SelectedCategory) then
        ItemNum = ItemNum + 1
        local Panel = ItemPanel:Add("DPanel")
        Panel:SetPos(0, ItemY)
        Panel:SetSize(ItemPanel:GetWide(), ItemPanel:GetTall() * 0.2)
        local PriceColor = Color(200, 200, 200, 255)
        if(LocalPlayer():canAfford(v.price)) then PriceColor = Color(0, 200, 0, 255) end
        Panel.Paint = function(s, w, h)
          draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 255))
          draw.SimpleText(v.name, "oshop_vgui2", w * 0.025, h * 0.1, Color(255, 255, 255, 255), 0, 0)
          draw.SimpleText(v.desc, "oshop_vgui1", w * 0.025, h * 0.6, Color(200, 200, 200, 255), 0, 0)
          surface.SetFont("oshop_vgui2")
          draw.SimpleText("$" .. string.Comma(v.price), "oshop_vgui1", surface.GetTextSize(v.name) + 25, h * 0.225, PriceColor, 0, 0)
        end

        local Buy = vgui.Create("DButton", Panel)
        Buy:SetPos(Panel:GetWide() * 0.75, Panel:GetTall() * 0.25)
        Buy:SetSize(Panel:GetWide() * 0.2, Panel:GetTall() * 0.5)
        Buy:SetText("")
        Buy.Paint = function(s, w, h)
          draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 255))
          draw.SimpleText(OShop.Lang.Buy, "oshop_vgui1", w / 2.05, h / 2, Color(255, 255, 255, 255), 1, 1)
        end
        Buy.DoClick = function()
          net.Start("oshop_requestpurchuse")
          net.WriteString(v.name)
          net.SendToServer()
          if(tobool(Config[2].ConfigValue) == true) then
            frame:Close()
          end
        end
        ItemY = ItemY + ItemPanel:GetTall() * 0.225
      end
    end
    if(ItemNum == 0) then
      local Panel = ItemPanel:Add("DPanel")
      Panel:SetPos(0, 0)
      Panel:SetSize(ItemPanel:GetWide(), ItemPanel:GetTall())
      Panel.Paint = function(s, w, h)
        draw.SimpleText(OShop.Lang.Nothing, "oshop_vgui1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
      end
    end
  end
  RebuildItems()

  local CategoryY = 0
  for k,v in ipairs(Categorys) do
    local Panel = CategoryPanel:Add("DButton")
    Panel:SetSize(CategoryPanel:GetWide(), CategoryPanel:GetTall() * 0.1)
    Panel:SetPos(0, CategoryY)
    Panel:SetText("")
    local PLerp = 0
    Panel.Paint = function(s, w, h)
      if(s:IsHovered() == true) then
        PLerp = Lerp(0.04, PLerp, w)
      else
        PLerp = Lerp(0.04, PLerp, 0)
      end
      draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 255))
      draw.RoundedBox(0, 0, 0, PLerp, h, Color(35, 35, 35, 255))
      draw.RoundedBox(0, 0, 0, w * 0.025, h, v.color)
      draw.SimpleText(v.name, "oshop_vgui1", w * 0.05, h * 0.05, Color(255, 255, 255, 255), 0, 0)
      draw.SimpleText(v.desc, "oshop_vgui3", w * 0.055, h * 0.55, Color(200, 200, 200, 255), 0, 0)
    end
    Panel.DoClick = function()
      SelectedCategory = v.name
      RebuildItems()
    end
    CategoryY = CategoryY + CategoryPanel:GetTall() * 0.12
  end
end







// Blur
OShop.Themes["Blur"] = function(Config, Categorys, Items)
  local blur = Material("pp/blurscreen")
  local function DrawBlur(panel, amount)
  	local x, y = panel:LocalToScreen(0, 0)
  	local scrW, scrH = ScrW(), ScrH()
  	surface.SetDrawColor(255, 255, 255)
  	surface.SetMaterial(blur)
  	for i = 1, 3 do
  		blur:SetFloat("$blur", (i / 3) * (amount or 6))
  		blur:Recompute()
  		render.UpdateScreenEffectTexture()
  		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
  	end
  end

  local function OutlinedBox(x, y, w, h, thickness, clr)
  	surface.SetDrawColor(clr)
  	for i=0, thickness - 1 do
  		surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2)
  	end
  end

  surface.CreateFont("oshop_vgui1", {
    font = Config[10].ConfigValue,
    size = ScrH() * 0.03
  })

  surface.CreateFont("oshop_vgui2", {
    font = Config[10].ConfigValue,
    size = ScrH() * 0.05
  })

  surface.CreateFont("oshop_vgui3", {
    font = Config[10].ConfigValue,
    size = ScrH() * 0.02
  })

  local frame = vgui.Create("DFrame")
  frame:SetSize(ScrW() * 0.6, ScrH() * 0.6)
  frame:SetTitle("")
  frame:SetDraggable(false)
  frame:ShowCloseButton(false)
  frame:Center()
  frame:MakePopup()
  frame.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    DrawBlur(frame, 10)
    draw.RoundedBox(0, 0, 0, w, h * 0.05, Color(0, 0, 0, 255))
    OutlinedBox(0, 0, w, h, 5, Color(0, 0, 0, 255))
    draw.SimpleText(Config[3].ConfigValue, "oshop_vgui1", w * 0.005, 0, Color(255, 255, 255), 0, 0)
  end

  local w,h = frame:GetWide(), frame:GetTall()

  local Close = vgui.Create("DButton", frame)
  Close:SetPos(w * 0.971, 0)
  Close:SetSize(w * 0.03, h * 0.05)
  Close:SetText("")
  Close.Paint = function(s, w, h)
    if(s:IsHovered() == true) then
      draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
    else
      draw.RoundedBox(0, 0, 0, w, h, Color(200, 0, 0, 255))
    end
    draw.SimpleText("X", "oshop_vgui1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
  end
  Close.DoClick = function()
    frame:Close()
  end

  local ThemeSelect = vgui.Create("DComboBox", frame)
  ThemeSelect:SetPos(w * 0.02, h * 0.925)
  ThemeSelect:SetSize(w * 0.25, h * 0.04)
  ThemeSelect:SetValue("Theme Select")
  ThemeSelect:AddChoice("Solid")
  ThemeSelect:AddChoice("Blur")
  ThemeSelect:AddChoice("Opacity")
  ThemeSelect.OnSelect = function(a, b, value)
    cookie.Set("oshop_theme", value)
    frame:Close()
    local PrefixCC = util.JSONToTable(Config[4].ConfigValue)
    local PrefixC = Color(PrefixCC.r, PrefixCC.g, PrefixCC.b, 255)
    local TextCC = util.JSONToTable(Config[11].ConfigValue)
    local TextC = Color(TextCC.r, TextCC.g, TextCC.b, 255)
    OShop.Message(Config[5].ConfigValue, string.format(OShop.Lang.ChangeTheme, value), tobool(Config[8].ConfigValue), tonumber(Config[14].ConfigValue), PrefixC, TextC)
  end

  local SelectedCategory = ""
  local CategoryPanel = vgui.Create("DScrollPanel", frame)
  CategoryPanel:SetSize(w * 0.25, h * 0.825)
  CategoryPanel:SetPos(w * 0.02, h * 0.075)
  CategoryPanel.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
  end

  local bar = CategoryPanel:GetVBar()
  function bar:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
  end
  function bar.btnUp:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnDown:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnGrip:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
  end

  local ItemPanel = vgui.Create("DScrollPanel", frame)
  ItemPanel:SetSize(w * 0.68, h * 0.89)
  ItemPanel:SetPos(w * 0.3, h * 0.075)
  ItemPanel.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
  end
  local bar = ItemPanel:GetVBar()
  function bar:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
  end
  function bar.btnUp:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnDown:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnGrip:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
  end

  local ItemY = 0
  local ItemNum = 0
  local function RebuildItems()
    ItemPanel:Clear()
    ItemY = 0
    ItemNum = 0
    for k,v in ipairs(Items) do
      if(v.category == SelectedCategory) then
        ItemNum = ItemNum + 1
        local Panel = ItemPanel:Add("DPanel")
        Panel:SetPos(0, ItemY)
        Panel:SetSize(ItemPanel:GetWide(), ItemPanel:GetTall() * 0.2)
        local PriceColor = Color(200, 200, 200, 255)
        if(LocalPlayer():canAfford(v.price)) then PriceColor = Color(0, 200, 0, 255) end
        Panel.Paint = function(s, w, h)
          OutlinedBox(0, 0, w, h, 1, Color(0, 0, 0, 255))
          draw.SimpleText(v.name, "oshop_vgui2", w * 0.025, h * 0.1, Color(255, 255, 255, 255), 0, 0)
          draw.SimpleText(v.desc, "oshop_vgui1", w * 0.025, h * 0.6, Color(200, 200, 200, 255), 0, 0)
          surface.SetFont("oshop_vgui2")
          draw.SimpleText("$" .. string.Comma(v.price), "oshop_vgui1", surface.GetTextSize(v.name) + 25, h * 0.225, PriceColor, 0, 0)
        end

        local Buy = vgui.Create("DButton", Panel)
        Buy:SetPos(Panel:GetWide() * 0.75, Panel:GetTall() * 0.25)
        Buy:SetSize(Panel:GetWide() * 0.2, Panel:GetTall() * 0.5)
        Buy:SetText("")
        Buy.Paint = function(s, w, h)
          draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 255))
          draw.SimpleText(OShop.Lang.Buy, "oshop_vgui1", w / 2.05, h / 2, Color(255, 255, 255, 255), 1, 1)
        end
        Buy.DoClick = function()
          net.Start("oshop_requestpurchuse")
          net.WriteString(v.name)
          net.SendToServer()
          if(tobool(Config[2].ConfigValue) == true) then
            frame:Close()
          end
        end
        ItemY = ItemY + ItemPanel:GetTall() * 0.225
      end
    end
    if(ItemNum == 0) then
      local Panel = ItemPanel:Add("DPanel")
      Panel:SetPos(0, 0)
      Panel:SetSize(ItemPanel:GetWide(), ItemPanel:GetTall())
      Panel.Paint = function(s, w, h)
        draw.SimpleText(OShop.Lang.Nothing, "oshop_vgui1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
      end
    end
  end
  RebuildItems()

  local CategoryY = 0
  for k,v in ipairs(Categorys) do
    local Panel = CategoryPanel:Add("DButton")
    Panel:SetSize(CategoryPanel:GetWide(), CategoryPanel:GetTall() * 0.1)
    Panel:SetPos(0, CategoryY)
    Panel:SetText("")
    local PLerp = 0
    Panel.Paint = function(s, w, h)
      if(s:IsHovered() == true) then
        PLerp = Lerp(0.04, PLerp, w)
      else
        PLerp = Lerp(0.04, PLerp, 0)
      end
      draw.RoundedBox(0, 0, 0, PLerp, h, Color(0, 0, 0, 150))
      draw.RoundedBox(0, 0, 0, w * 0.025, h, v.color)
      OutlinedBox(0, 0, w, h, 1, Color(0, 0, 0, 255))
      draw.SimpleText(v.name, "oshop_vgui1", w * 0.04, h * 0.05, Color(255, 255, 255, 255), 0, 0)
      draw.SimpleText(v.desc, "oshop_vgui3", w * 0.045, h * 0.55, Color(200, 200, 200, 255), 0, 0)
    end
    Panel.DoClick = function()
      SelectedCategory = v.name
      RebuildItems()
    end
    CategoryY = CategoryY + CategoryPanel:GetTall() * 0.12
  end
end







// Opacity
OShop.Themes["Opacity"] = function(Config, Categorys, Items)
  surface.CreateFont("oshop_vgui1", {
    font = Config[10].ConfigValue,
    size = ScrH() * 0.03
  })

  surface.CreateFont("oshop_vgui2", {
    font = Config[10].ConfigValue,
    size = ScrH() * 0.05
  })

  surface.CreateFont("oshop_vgui3", {
    font = Config[10].ConfigValue,
    size = ScrH() * 0.02
  })

  local frame = vgui.Create("DFrame")
  frame:SetSize(ScrW() * 0.6, ScrH() * 0.6)
  frame:SetTitle("")
  frame:SetDraggable(false)
  frame:ShowCloseButton(false)
  frame:Center()
  frame:MakePopup()
  frame.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    draw.RoundedBox(0, 0, 0, w, h * 0.05, Color(0, 0, 0, 200))
    draw.SimpleText(Config[3].ConfigValue, "oshop_vgui1", w * 0.005, 0, Color(255, 255, 255), 0, 0)
  end

  local w,h = frame:GetWide(), frame:GetTall()

  local Close = vgui.Create("DButton", frame)
  Close:SetPos(w * 0.971, 0)
  Close:SetSize(w * 0.03, h * 0.05)
  Close:SetText("")
  Close.Paint = function(s, w, h)
    if(s:IsHovered() == true) then
      draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 200))
    else
      draw.RoundedBox(0, 0, 0, w, h, Color(200, 0, 0, 200))
    end
    draw.SimpleText("X", "oshop_vgui1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
  end
  Close.DoClick = function()
    frame:Close()
  end

  local ThemeSelect = vgui.Create("DComboBox", frame)
  ThemeSelect:SetPos(w * 0.02, h * 0.925)
  ThemeSelect:SetSize(w * 0.25, h * 0.04)
  ThemeSelect:SetValue("Theme Select")
  ThemeSelect:AddChoice("Solid")
  ThemeSelect:AddChoice("Blur")
  ThemeSelect:AddChoice("Opacity")
  ThemeSelect.OnSelect = function(a, b, value)
    cookie.Set("oshop_theme", value)
    frame:Close()
    local PrefixCC = util.JSONToTable(Config[4].ConfigValue)
    local PrefixC = Color(PrefixCC.r, PrefixCC.g, PrefixCC.b, 255)
    local TextCC = util.JSONToTable(Config[11].ConfigValue)
    local TextC = Color(TextCC.r, TextCC.g, TextCC.b, 255)
    OShop.Message(Config[5].ConfigValue, string.format(OShop.Lang.ChangeTheme, value), tobool(Config[8].ConfigValue), tonumber(Config[14].ConfigValue), PrefixC, TextC)
  end

  local SelectedCategory = ""
  local CategoryPanel = vgui.Create("DScrollPanel", frame)
  CategoryPanel:SetSize(w * 0.25, h * 0.825)
  CategoryPanel:SetPos(w * 0.02, h * 0.075)
  CategoryPanel.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
  end

  local bar = CategoryPanel:GetVBar()
  function bar:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
  end
  function bar.btnUp:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnDown:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnGrip:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
  end

  local ItemPanel = vgui.Create("DScrollPanel", frame)
  ItemPanel:SetSize(w * 0.68, h * 0.89)
  ItemPanel:SetPos(w * 0.3, h * 0.075)
  ItemPanel.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
  end
  local bar = ItemPanel:GetVBar()
  function bar:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
  end
  function bar.btnUp:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnDown:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function bar.btnGrip:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
  end

  local ItemY = 0
  local ItemNum = 0
  local function RebuildItems()
    ItemPanel:Clear()
    ItemY = 0
    ItemNum = 0
    for k,v in ipairs(Items) do
      if(v.category == SelectedCategory) then
        ItemNum = ItemNum + 1
        local Panel = ItemPanel:Add("DPanel")
        Panel:SetPos(0, ItemY)
        Panel:SetSize(ItemPanel:GetWide(), ItemPanel:GetTall() * 0.2)
        local PriceColor = Color(200, 200, 200, 255)
        if(LocalPlayer():canAfford(v.price)) then PriceColor = Color(0, 200, 0, 255) end
        Panel.Paint = function(s, w, h)
          draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
          draw.SimpleText(v.name, "oshop_vgui2", w * 0.025, h * 0.1, Color(255, 255, 255, 200), 0, 0)
          draw.SimpleText(v.desc, "oshop_vgui1", w * 0.025, h * 0.6, Color(200, 200, 200, 200), 0, 0)
          surface.SetFont("oshop_vgui2")
          draw.SimpleText("$" .. string.Comma(v.price), "oshop_vgui1", surface.GetTextSize(v.name) + 25, h * 0.225, PriceColor, 0, 0)
        end

        local Buy = vgui.Create("DButton", Panel)
        Buy:SetPos(Panel:GetWide() * 0.75, Panel:GetTall() * 0.25)
        Buy:SetSize(Panel:GetWide() * 0.2, Panel:GetTall() * 0.5)
        Buy:SetText("")
        Buy.Paint = function(s, w, h)
          draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
          draw.SimpleText(OShop.Lang.Buy, "oshop_vgui1", w / 2.05, h / 2, Color(255, 255, 255, 255), 1, 1)
        end
        Buy.DoClick = function()
          net.Start("oshop_requestpurchuse")
          net.WriteString(v.name)
          net.SendToServer()
          if(tobool(Config[2].ConfigValue) == true) then
            frame:Close()
          end
        end
        ItemY = ItemY + ItemPanel:GetTall() * 0.225
      end
    end
    if(ItemNum == 0) then
      local Panel = ItemPanel:Add("DPanel")
      Panel:SetPos(0, 0)
      Panel:SetSize(ItemPanel:GetWide(), ItemPanel:GetTall())
      Panel.Paint = function(s, w, h)
        draw.SimpleText(OShop.Lang.Nothing, "oshop_vgui1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
      end
    end
  end
  RebuildItems()

  local CategoryY = 0
  for k,v in ipairs(Categorys) do
    local Panel = CategoryPanel:Add("DButton")
    Panel:SetSize(CategoryPanel:GetWide(), CategoryPanel:GetTall() * 0.1)
    Panel:SetPos(0, CategoryY)
    Panel:SetText("")
    local PLerp = 0
    Panel.Paint = function(s, w, h)
      if(s:IsHovered() == true) then
        PLerp = Lerp(0.04, PLerp, w)
      else
        PLerp = Lerp(0.04, PLerp, 0)
      end
      draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
      draw.RoundedBox(0, 0, 0, PLerp, h, Color(35, 35, 35, 200))
      draw.RoundedBox(0, 0, 0, w * 0.025, h, v.color)
      draw.SimpleText(v.name, "oshop_vgui1", w * 0.05, h * 0.05, Color(255, 255, 255, 255), 0, 0)
      draw.SimpleText(v.desc, "oshop_vgui3", w * 0.055, h * 0.55, Color(200, 200, 200, 255), 0, 0)
    end
    Panel.DoClick = function()
      SelectedCategory = v.name
      RebuildItems()
    end
    CategoryY = CategoryY + CategoryPanel:GetTall() * 0.12
  end
end
