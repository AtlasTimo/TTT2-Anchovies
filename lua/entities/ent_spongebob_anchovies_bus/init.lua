AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local BUS_STATE = 1
local TARGET_HIT_PLAYER_STATE = 2
local PATROL_STATE = 3
local TARGET_FOUND_PLAYER_STATE = 4
local RETURNING_STATE = 5
local RETURNED_STATE = 6

function ENT:Initialize()
	if ((math.random(100) < 10) or (SPONGEBOB_ANCHOVIES.CVARS.use_alt_sound_only)) then
		self.shootSound = Sound("anchovies/anchovies_shark.ogg")
	else
		if (SPONGEBOB_ANCHOVIES.CVARS.use_german_sound) then
			self.shootSound = Sound("anchovies/anchovies_standard_de.ogg")
		else
			self.shootSound = Sound("anchovies/anchovies_standard_en.ogg")
		end
	end

	self:InitBus()
	self:CreateSpriteCenterEnt()
	self:ResetVars()

	timer.Simple(2.3, function()
		if (#self.playersHitByBus > 0) then
			self:SetState(TARGET_HIT_PLAYER_STATE)
		else
			self:UpdatePatrolBox()
			self:SetState(PATROL_STATE)
		end
		self:CreateAnchovies()
	end)

	timer.Create("spongebob_anchovies_final_remove_timer", 39, 0, function()
		if (IsValid(self.spritecenterentity)) then
			self:DestroyAnchovies()
			self.spritecenterentity:Remove()
		end
		if (IsValid(self.anchoviesOwner) and self.anchoviesOwner:Alive() and self.anchoviesOwner:GetObserverMode() == OBS_MODE_NONE) then
			self.anchoviesOwner:StripWeapon("weapon_anchovies")
		end
		if (IsValid(self)) then
			self:Remove()
		end
	end)
end

function ENT:Think()
	if (SPONGEBOB_ANCHOVIES.CVARS.use_max_hits) then
		if ((self.hitCounter >= SPONGEBOB_ANCHOVIES.CVARS.anchovies_max_hits) and (self.currentState ~= RETURNING_STATE)) then
			if (self.anchoviesOwner:Alive() and self.anchoviesOwner:GetObserverMode() == OBS_MODE_NONE) then
				self.anchoviesOwner:StripWeapon("weapon_anchovies")
			end

			self:SetState(RETURNING_STATE)
		end
	end

	if (self.currentState == BUS_STATE) then
		self:BusState()
	elseif (self.currentState == TARGET_HIT_PLAYER_STATE) then
		self:TargetPlayersHitByBusState()
	elseif (self.currentState == PATROL_STATE) then
		self:PatrolState()
	elseif (self.currentState == TARGET_FOUND_PLAYER_STATE) then
		self:TargetFoundPlayerState()
	elseif (self.currentState == RETURNING_STATE) then
		self:ReturningState()
	else
		if (self.currentState ~= RETURNED_STATE) then
			self:DestroyAnchovies()
			self.spritecenterentity:Remove()
			self:Remove()
		end
	end

	self:NextThink(CurTime() + 1 / 30)
	return true
end

function ENT:InitBus()
	self:SetModel("models/spongebob_anchovies/spongebob_anchovies_bus_model/bus.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:PhysWake()
	self:DrawShadow(false)
end

function ENT:ResetVars()
	self.currentState = BUS_STATE
	self.spriterandomx = {}
	self.spriterandomy = {}
	self.spriteents = {}
	self.playersNotHitByBus = {}
	self.playersHitByBus = {}
	self.anchoviesOwner = self:GetOwner()
	self:CreateGeneralPlayerTable()
	self.playersHitByAnchovies = {}
	self:CreatePatrolBoxReference()
	self.hitCounter = 0
end

function ENT:CreateSpriteCenterEnt()
	self.spritecenterentity = ents.Create("ent_spongebob_anchovies_anchovie")
	self.spritecenterentity:SetPos(self:GetPos())
	self.spritecenterentity:Spawn()
	self.spritecenterentity:EmitSound(self.shootSound, 100, 100, 1)
end

function ENT:SetState(newState)
	self.currentState = newState
end

function ENT:CreateAnchovies()
	for i = 1, SPONGEBOB_ANCHOVIES.CVARS.anchovies_amount do
		self.spriterandomx[i] = math.random(-120, 120)
		self.spriterandomy[i] = math.random(-120, 120)
	
		self.spriteents[i] = ents.Create("ent_spongebob_anchovies_anchovie")

		self.spriteents[i]:SetParent(self.spritecenterentity, -1)
		self.spriteents[i]:SetLocalPos(Vector(self.spriterandomx[i], self.spriterandomy[i], 0))

		self.spriteents[i]:Spawn()
	end
end

function ENT:DestroyAnchovies()
	for i, v in pairs(self.spriteents) do
		if not IsValid(v) then continue end
		v:Remove()
	end
	self.spritecenterentity:SetParent(self.Entity)
	self.spritecenterentity:StopSound(self.shootSound)
end

function ENT:CreateGeneralPlayerTable()
	for i, v in pairs(player.GetAll()) do
		if (v:GetName() ~= self.anchoviesOwner:GetName()) then
			if ((v:Alive()) and (v:GetObserverMode() == OBS_MODE_NONE)) then
				if (v:GetTeam() ~= self.anchoviesOwner:GetTeam() and v:GetTeam() ~= "jesters" and self.anchoviesOwner:GetTeam() == "traitors" or self.anchoviesOwner:GetTeam() == "jackals" or self.anchoviesOwner:GetTeam() == "infecteds" or self.anchoviesOwner:GetTeam() == "nones") then
					self:AddPlayerToTable(v, self.playersNotHitByBus)
				elseif ((v:GetTeam() ~= self.anchoviesOwner:GetTeam() and self.anchoviesOwner:GetTeam() == "innocents" and v:GetTeam() ~= "nones")) then
					self:AddPlayerToTable(v, self.playersNotHitByBus)
				end
			end 
		end
	end
end

function ENT:AddPlayerToTable(p, t)					--Player p, Table t
	table.insert(t, p)
end

function ENT:DamagePlayer(p, dmga, a)				--Player p. Damage Amound dmga
	p:TakeDamage(dmga, a, self.weapon)
end

function ENT:SetWeapon(weapon)
	self.weapon = weapon
end

function ENT:MoveAnchoviesToPos(pos, s)				--Position pos, Speed s
	local movementvector = pos - self.spritecenterentity:GetPos()
	movementvector:Normalize()
	movementvector = movementvector * s
	self.spritecenterentity:SetPos(movementvector + self.spritecenterentity:GetPos())
end

function ENT:MoveAnchoviesToPlayer(tp, s)			--Targetplayer tp, Speed s
	local movementvector = tp:GetPos() - self.spritecenterentity:GetPos()
	movementvector:Normalize()
	movementvector = movementvector * s
	self.spritecenterentity:SetPos(movementvector + self.spritecenterentity:GetPos() + Vector(0,0,2))
end

function ENT:CreatePatrolBoxReference()
	local refVec = self:GetPos()
	self.patrolBoxMinVector = Vector(refVec[1] - 10, refVec[2] - 10, refVec[3] - 10)
	self.patrolBoxMaxVector = Vector(refVec[1] + 10, refVec[2] + 10, refVec[3] + 10)
end

function ENT:UpdatePatrolBox()
	for i, v in pairs(player.GetAll()) do
		if ((not v:Alive()) or (v:GetObserverMode() ~= OBS_MODE_NONE)) then
			continue
		end

		local playerPos = v:GetPos()

		if (playerPos.x > self.patrolBoxMaxVector.x) then
			self.patrolBoxMaxVector.x = playerPos.x
		elseif (playerPos.x < self.patrolBoxMinVector.x) then
			self.patrolBoxMinVector.x = playerPos.x
		end

		if (playerPos.y > self.patrolBoxMaxVector.y) then
			self.patrolBoxMaxVector.y = playerPos.y
		elseif (playerPos.y < self.patrolBoxMinVector.y) then
			self.patrolBoxMinVector.y = playerPos.y
		end

		if (playerPos.z > self.patrolBoxMaxVector.z) then
			self.patrolBoxMaxVector.z = playerPos.z
		elseif (playerPos.z < self.patrolBoxMinVector.z) then
			self.patrolBoxMinVector.z = playerPos.z
		end

	end
end

function ENT:BusState()
	self.spritecenterentity:SetPos(self:GetPos())

	for i, v in pairs(self.playersNotHitByBus) do
		if (not IsValid(v)) then
			table.remove(self.playersNotHitByBus, i)
			continue
		end

		local distancevector = v:GetPos() - self:GetPos()
		if (distancevector:Length() <= 150) then
			table.remove(self.playersNotHitByBus, i)
			table.insert(self.playersHitByBus, v)
			local playerImpuleVelocity = self:GetVelocity()
			playerImpuleVelocity:Normalize()
			v:SetVelocity((playerImpuleVelocity + Vector(0, 0, 2)) * 200)
			self:DamagePlayer(v, SPONGEBOB_ANCHOVIES.CVARS.anchovies_bus_damage, self.anchoviesOwner)
		end
	end
end

function ENT:TargetPlayersHitByBusState()
	local targetplayer = self.playersHitByBus[1]
	while (not targetplayer:Alive()) or (targetplayer:GetObserverMode() ~= OBS_MODE_NONE) do
		table.remove(self.playersHitByBus, 1)
		if (#self.playersHitByBus <= 0) then
			if (#self.playersNotHitByBus <= 0) then
				if (self.anchoviesOwner:Alive() and self.anchoviesOwner:GetObserverMode() == OBS_MODE_NONE) then
					self.anchoviesOwner:StripWeapon("weapon_anchovies")
				end
				self:SetState(RETURNING_STATE)
			else
				self:UpdatePatrolBox()
				self:SetState(PATROL_STATE)
			end
			return
		end
		targetplayer = self.playersHitByBus[1]
	end

	self:MoveAnchoviesToPlayer(targetplayer, SPONGEBOB_ANCHOVIES.CVARS.anchovies_target_speed)

	local distancevector = self.spritecenterentity:GetPos() - targetplayer:GetPos()
	if (distancevector:Length() <= 60) then
		table.remove(self.playersHitByBus, 1)
		self:DamagePlayer(targetplayer, SPONGEBOB_ANCHOVIES.CVARS.anchovies_hit_player_damage, self.anchoviesOwner)
		self.hitCounter = self.hitCounter + 1
	end

	if (#self.playersHitByBus <= 0) then
		if (#self.playersNotHitByBus <= 0) then
			if (self.anchoviesOwner:Alive() and self.anchoviesOwner:GetObserverMode() == OBS_MODE_NONE) then
				self.anchoviesOwner:StripWeapon("weapon_anchovies")
			end
			self:SetState(RETURNING_STATE)
		else
			self:UpdatePatrolBox()
			self:SetState(PATROL_STATE)
		end
	end
end

function ENT:PatrolState()
	if (self.patrolToPos == nil) then
		self.patrolToPos = Vector(math.random(self.patrolBoxMinVector.x, self.patrolBoxMaxVector.x), math.random(self.patrolBoxMinVector.y, self.patrolBoxMaxVector.y),math.random(self.patrolBoxMinVector.z, self.patrolBoxMaxVector.z))
	end

	self:MoveAnchoviesToPos(self.patrolToPos, SPONGEBOB_ANCHOVIES.CVARS.anchovies_patrol_speed)

	for i, v in pairs(self.playersNotHitByBus) do
		local distancevector = self.spritecenterentity:GetPos() - v:GetPos()
		if (distancevector:Length() <= SPONGEBOB_ANCHOVIES.CVARS.anchovies_sighting_range) then
			self.patrolTargetPlayer = v
			self:SetState(TARGET_FOUND_PLAYER_STATE)
		end
	end

	local distancevector = self.spritecenterentity:GetPos() - self.patrolToPos
	if (distancevector:Length() <= 60) then
		self:UpdatePatrolBox()
		self.patrolToPos = nil
	end
end

function ENT:TargetFoundPlayerState()
	local targetplayer = self.patrolTargetPlayer
	if (not targetplayer:Alive()) or (targetplayer:GetObserverMode() ~= OBS_MODE_NONE) then
		self:SetState(PATROL_STATE)
	end

	self:MoveAnchoviesToPlayer(targetplayer, SPONGEBOB_ANCHOVIES.CVARS.anchovies_target_speed)

	local distancevector = self.spritecenterentity:GetPos() - targetplayer:GetPos()

	if (distancevector:Length() <= 60) then
		table.RemoveByValue(self.playersNotHitByBus, targetplayer)
		self:DamagePlayer(targetplayer, SPONGEBOB_ANCHOVIES.CVARS.anchovies_not_hit_player_damage, self.anchoviesOwner)
		self.hitCounter = self.hitCounter + 1
		self:SetState(PATROL_STATE)
	end

	if (#self.playersNotHitByBus <= 0) then
		if (self.anchoviesOwner:Alive() and self.anchoviesOwner:GetObserverMode() == OBS_MODE_NONE) then
			self.anchoviesOwner:StripWeapon("weapon_anchovies")
		end
		self:SetState(RETURNING_STATE)
	end
end

function ENT:ReturningState()
	self:MoveAnchoviesToPos(self:GetPos(), SPONGEBOB_ANCHOVIES.CVARS.anchovies_patrol_speed)

	local distancevector = self.spritecenterentity:GetPos() - self:GetPos()
	if (distancevector:Length() <= 20) then
		timer.Stop("spongebob_anchovies_final_remove_timer")
		self:SetState(RETURNED_STATE)
		self:DestroyAnchovies()
		self:ReturnedState()
	end
end

function ENT:ReturnedState()
	timer.Simple(3, function()
		if (IsValid(self.spritecenterentity)) then
			self.spritecenterentity:Remove()
		end
		if (IsValid(self)) then
			self:Remove()
		end
	end)
end