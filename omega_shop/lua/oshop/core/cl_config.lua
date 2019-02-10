net.Receive("oshop_openconfig", function()
  local ConfigTable = net.ReadTable()
  local ConfigCategorys = ConfigCategorys or {}
  local CategorySelected = "None"

  surface.CreateFont("oshop_config1", {
    font = ConfigTable[10].ConfigValue,
    size = ScrH() * 0.031
  })
  surface.CreateFont("oshop_config2", {
    font = ConfigTable[10].ConfigValue,
    size = ScrH() * 0.04
  })
  surface.CreateFont("oshop_config3", {
    font = ConfigTable[10].ConfigValue,
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
    draw.SimpleText(OShop.Lang.ConfigurationTitle, "oshop_config1", w * 0.005, 0, Color(255, 255, 255), 0, 0)
  end

  local fw,fh = frame:GetWide(), frame:GetTall()

  local Close = vgui.Create("DButton", frame)
  Close:SetPos(fw * 0.971, 0)
  Close:SetSize(fw * 0.03, fh * 0.05)
  Close:SetText("")
  Close.Paint = function(s, w, h)
    if(s:IsHovered() == true) then
      draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
    else
      draw.RoundedBox(0, 0, 0, w, h, Color(200, 0, 0, 255))
    end
    draw.SimpleText("X", "oshop_config1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
  end
  Close.DoClick = function()
    frame:Close()
  end

  for k,v in pairs(ConfigTable) do
    if(!table.HasValue(ConfigCategorys, v.Category)) then
        table.insert(ConfigCategorys, v.Category)
    end
  end

  local ItemScroll = vgui.Create("DScrollPanel", frame)
  ItemScroll:SetPos(fw * 0.25, fh * 0.075)
  ItemScroll:SetSize(fw * 0.725, fh * 0.89)
  ItemScroll.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
  end
  local ItemBar = ItemScroll:GetVBar()
  function ItemBar:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
  end
  function ItemBar.btnUp:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function ItemBar.btnDown:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function ItemBar.btnGrip:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
  end

  local function RebuildConfig()
    ItemScroll:Clear()
    if(CategorySelected == "None") then
      local DPanel = ItemScroll:Add("DPanel")
      DPanel:SetSize(ItemScroll:GetWide(), ItemScroll:GetTall())
      DPanel.Paint = function(s, w, h)
        draw.SimpleText(OShop.Lang.ConfigNone, "oshop_config1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
      end
    else
      for k,v in pairs(ConfigTable) do
        if(v.Category == CategorySelected) then
          local DPanel = ItemScroll:Add("DPanel")
          DPanel:Dock(TOP)
          DPanel:DockMargin(0, 0, 0, ItemScroll:GetTall() * 0.01)
          DPanel:SetSize(ItemScroll:GetWide(), ItemScroll:GetTall() * 0.2)
          DPanel.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
            draw.SimpleText(v.Name, "oshop_config2", w * 0.025, h * 0.1, Color(255, 255, 255, 255), 0, 0)
            draw.SimpleText(v.Description, "oshop_config3", w * 0.025, h * 0.5, Color(255, 255, 255, 255), 0, 0)
          end

          if(v.Type == "String") then
            local DTextEntry = vgui.Create("DTextEntry", DPanel)
            DTextEntry:SetPos(DPanel:GetWide() * 0.025, DPanel:GetTall() * 0.75)
            DTextEntry:SetSize(DPanel:GetWide() * 0.8, DPanel:GetTall() * 0.2)
            DTextEntry:SetText(v.ConfigValue)

            local SaveButton = vgui.Create("DButton", DPanel)
            SaveButton:SetPos(DPanel:GetWide() * 0.85, DPanel:GetTall() * 0.75)
            SaveButton:SetSize(DPanel:GetWide() * 0.1, DPanel:GetTall() * 0.2)
            SaveButton:SetText("")
            SaveButton.Paint = function(s, w, h)
              draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
              draw.SimpleText(OShop.Lang.ConfigSave, "oshop_config3", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
            end
            SaveButton.DoClick = function()
              net.Start("oshop_changeconfig")
              net.WriteString(v.ConfigKey)
              net.WriteString(v.Type)
              net.WriteString(DTextEntry:GetValue())
              net.SendToServer()
            end
          end
          if(v.Type == "Bool") then
            local Checkbox = vgui.Create("DCheckBox", DPanel)
            Checkbox:SetPos(DPanel:GetWide() * 0.025, DPanel:GetTall() * 0.75)
            Checkbox:SetValue(v.ConfigValue)

            local SaveButton = vgui.Create("DButton", DPanel)
            SaveButton:SetPos(DPanel:GetWide() * 0.85, DPanel:GetTall() * 0.75)
            SaveButton:SetSize(DPanel:GetWide() * 0.1, DPanel:GetTall() * 0.2)
            SaveButton:SetText("")
            SaveButton.Paint = function(s, w, h)
              draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
              draw.SimpleText(OShop.Lang.ConfigSave, "oshop_config3", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
            end
            SaveButton.DoClick = function()
              net.Start("oshop_changeconfig")
              net.WriteString(v.ConfigKey)
              net.WriteString(v.Type)
              net.WriteBool(Checkbox:GetChecked())
              net.SendToServer()
            end
          end
          if(v.Type == "Color") then
            local R = vgui.Create("DTextEntry", DPanel)
            R:SetPos(DPanel:GetWide() * 0.025, DPanel:GetTall() * 0.75)
            R:SetSize(DPanel:GetWide() * 0.075, DPanel:GetTall() * 0.2)
            R:SetText(util.JSONToTable(v.ConfigValue).r)

            local G = vgui.Create("DTextEntry", DPanel)
            G:SetPos(DPanel:GetWide() * 0.15, DPanel:GetTall() * 0.75)
            G:SetSize(DPanel:GetWide() * 0.075, DPanel:GetTall() * 0.2)
            G:SetText(util.JSONToTable(v.ConfigValue).g)

            local B = vgui.Create("DTextEntry", DPanel)
            B:SetPos(DPanel:GetWide() * 0.275, DPanel:GetTall() * 0.75)
            B:SetSize(DPanel:GetWide() * 0.075, DPanel:GetTall() * 0.2)
            B:SetText(util.JSONToTable(v.ConfigValue).b)

            local SaveButton = vgui.Create("DButton", DPanel)
            SaveButton:SetPos(DPanel:GetWide() * 0.85, DPanel:GetTall() * 0.75)
            SaveButton:SetSize(DPanel:GetWide() * 0.1, DPanel:GetTall() * 0.2)
            SaveButton:SetText("")
            SaveButton.Paint = function(s, w, h)
              draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
              draw.SimpleText(OShop.Lang.ConfigSave, "oshop_config3", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
            end
            SaveButton.DoClick = function()
              net.Start("oshop_changeconfig")
              net.WriteString(v.ConfigKey)
              net.WriteString(v.Type)
              net.WriteColor(Color(R:GetValue(), G:GetValue(), B:GetValue(), 255))
              net.SendToServer()
            end
          end
          if(v.Type == "Table") then
            local DTextEntry = vgui.Create("DTextEntry", DPanel)
            DTextEntry:SetPos(DPanel:GetWide() * 0.025, DPanel:GetTall() * 0.75)
            DTextEntry:SetSize(DPanel:GetWide() * 0.8, DPanel:GetTall() * 0.2)
            DTextEntry:SetText(v.ConfigValue)

            local SaveButton = vgui.Create("DButton", DPanel)
            SaveButton:SetPos(DPanel:GetWide() * 0.85, DPanel:GetTall() * 0.75)
            SaveButton:SetSize(DPanel:GetWide() * 0.1, DPanel:GetTall() * 0.2)
            SaveButton:SetText("")
            SaveButton.Paint = function(s, w, h)
              draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
              draw.SimpleText(OShop.Lang.ConfigSave, "oshop_config3", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
            end
            SaveButton.DoClick = function()
              net.Start("oshop_changeconfig")
              net.WriteString(v.ConfigKey)
              net.WriteString(v.Type)
              net.WriteString(DTextEntry:GetValue())
              net.SendToServer()
            end
          end
          if(v.Type == "Int") then
            local DNumberWang = vgui.Create("DNumberWang", DPanel)
            DNumberWang:SetPos(DPanel:GetWide() * 0.025, DPanel:GetTall() * 0.75)
            DNumberWang:SetValue(v.ConfigValue)

            local SaveButton = vgui.Create("DButton", DPanel)
            SaveButton:SetPos(DPanel:GetWide() * 0.85, DPanel:GetTall() * 0.75)
            SaveButton:SetSize(DPanel:GetWide() * 0.1, DPanel:GetTall() * 0.2)
            SaveButton:SetText("")
            SaveButton.Paint = function(s, w, h)
              draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
              draw.SimpleText(OShop.Lang.ConfigSave, "oshop_config3", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
            end
            SaveButton.DoClick = function()
              net.Start("oshop_changeconfig")
              net.WriteString(v.ConfigKey)
              net.WriteString(v.Type)
              net.WriteInt(DNumberWang:GetValue(), 32)
              net.SendToServer()
            end
          end
        end
      end
    end
  end
  RebuildConfig()

  local CategoryScroll = vgui.Create("DScrollPanel", frame)
  CategoryScroll:SetPos(fw * 0.02, fh * 0.075)
  CategoryScroll:SetSize(fw * 0.2, fh * 0.89)
  CategoryScroll.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
  end
  local CategoryBar = CategoryScroll:GetVBar()
  function CategoryBar:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
  end
  function CategoryBar.btnUp:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function CategoryBar.btnDown:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
  end
  function CategoryBar.btnGrip:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
  end

  for k,v in pairs(table.Reverse(ConfigCategorys)) do
    local DButton = CategoryScroll:Add("DButton")
    DButton:SetText("")
    DButton:Dock(TOP)
    DButton:DockMargin(0, 0, 0, CategoryScroll:GetTall() * 0.01)
    DButton:SetSize(CategoryScroll:GetWide(), CategoryScroll:GetTall() * 0.1)
    DButton.Paint = function(s, w, h)
      draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
      draw.SimpleText(v, "oshop_config1", w * 0.05, h / 2, Color(255, 255, 255, 255), 0, 1)
    end
    DButton.DoClick = function()
      CategorySelected = v
      RebuildConfig()
    end
  end
end)