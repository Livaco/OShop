AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("oshop/config/config.lua")
include("oshop/config/lang.lua")

function ENT:Initialize()
	self:SetModel(OShop.Config.NPC.Model)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetTrigger(true)
end

function ENT:AcceptInput(name, activator, ply)
	if(!IsValid(ply) or ply:IsBot()) then return end
	net.Start("oshop_openshop")
	net.WriteTable(OShop.Categorys)
	net.WriteTable(OShop.Items)
	net.Send(ply)
	OShop.SVMessage(ply, OShop.Lang.Opening)
end