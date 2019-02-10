AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("oshop/config/config.lua")
include("oshop/config/lang.lua")

function ENT:Initialize()
	self:SetModel(OShop.GetConfigValue("NPCModel")[1].ConfigValue)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetTrigger(true)
	self:SetThreeDeeTwoDee(OShop.GetConfigValue("NPC3D2D")[1].ConfigValue)
end

function ENT:AcceptInput(name, activator, ply)
	if(!IsValid(ply) or ply:IsBot()) then return end
	net.Start("oshop_openshop")
	net.WriteTable(OShop.GetConfig())
	net.WriteTable(OShop.Categorys)
	net.WriteTable(OShop.Items)
	net.Send(ply)
	OShop.SVMessage(ply, OShop.Lang.Opening)
end

function ENT:Think()
	self:SetThreeDeeTwoDee(OShop.GetConfigValue("NPC3D2D")[1].ConfigValue)
	self:SetThreeDeeStare(tobool(OShop.GetConfigValue("NPC3D2DFollow")[1].ConfigValue))
end