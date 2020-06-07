ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "NPC"
ENT.Category = "OShop"
ENT.Spawnable = true
ENT.AutomaticFrameAdvance = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
  self:NetworkVar("String", 1, "ThreeDeeTwoDee")
  self:NetworkVar("Bool", 2, "ThreeDeeStare")
end
