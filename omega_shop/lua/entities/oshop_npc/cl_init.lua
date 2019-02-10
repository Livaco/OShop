include("shared.lua")
include("oshop/config/lang.lua")
include("oshop/config/config.lua")

surface.CreateFont("oshop_npc1", {
	font = OShop.Config.Font,
	size = 50
})

function ENT:Initalize()
	self.AutomaticFrameAdvance = true
end

function ENT:Draw()
	self:DrawModel()

  local ang = self:GetAngles()
  local lpos = Vector(0, 0, 80)
  local pos = self:LocalToWorld(lpos)
  ang:RotateAroundAxis(self:GetAngles():Forward(), 90)
  ang:RotateAroundAxis(self:GetAngles():Up(), 90)
	if(self:GetThreeDeeStare() == true) then
	  eye_angles = LocalPlayer():EyeAngles()
	  ang = Angle(0, eye_angles.y - 90, -eye_angles.p - 270)
	end
	surface.SetFont("oshop_npc1")
  local Length = surface.GetTextSize(self:GetThreeDeeTwoDee()) + 50

	cam.Start3D2D(pos, ang, 0.1)
	draw.RoundedBox(0, (Length / 2) * -1, 0, Length, 50, Color(0, 0, 0, 200))
	draw.SimpleText(self:GetThreeDeeTwoDee(), "oshop_npc1", 0, 0, Color(255, 255, 255), 1, 0)
	cam.End3D2D()
end
