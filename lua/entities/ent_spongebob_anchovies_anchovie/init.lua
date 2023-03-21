AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:PhysicsInitBox(Vector(-25,-25,0), Vector(25,25,60)) 
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:EnableCustomCollisions(true)
	self:PhysWake()
	self:DrawShadow(false)
end