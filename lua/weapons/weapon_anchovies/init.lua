AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 100.0)
	local bus = ents.Create("ent_spongebob_anchovies_bus")
	local anowner = self:GetOwner()
	bus:SetPos(anowner:EyePos())
	bus:SetOwner(anowner)
	bus:Spawn()
	bus:SetWeapon(self)
	self.AllowDrop = false

	local p = bus:GetPhysicsObject()
	if (not IsValid(p)) then return end

	local velocity = anowner:GetAimVector()
	p:SetAngles(anowner:EyeAngles())
	p:ApplyForceCenter(velocity * SPONGEBOB_ANCHOVIES.CVARS.anchovies_bus_speed * 100000)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 10.0)
	local anowner = self:GetOwner()
	local randomsoundnum = math.random(1, 3)
	local secondarySound = Sound("anchovies/this_is_patrick_" .. randomsoundnum .. ".ogg")
	anowner:EmitSound(secondarySound, 100, 100, 1)
	timer.Simple(0.5, function()
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end)
end

function SWEP:OnDrop()
	if (self.AllowDrop) then return end
	self:Remove()
end