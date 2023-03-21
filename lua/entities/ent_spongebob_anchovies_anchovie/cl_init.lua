include("shared.lua")

local materials = {"spongebob_anchovies/spongebob_anchovies_anchovie_mats/anchovie_1.png",
"spongebob_anchovies/spongebob_anchovies_anchovie_mats/anchovie_2.png",
"spongebob_anchovies/spongebob_anchovies_anchovie_mats/anchovie_3.png",
"spongebob_anchovies/spongebob_anchovies_anchovie_mats/anchovie_4.png"}

function ENT:Initialize()
	local randspritenumber = 1
	
	if (math.random(100) < 30) then
		randspritenumber = math.random(3, 4)
	else
		randspritenumber = math.random(1, 2)
	end
	
	self.selfMaterial = Material(materials[randspritenumber])

	self:DrawShadow(false)
end

function ENT:Draw()
	local pos = self.Entity:GetPos()
	render.SetMaterial( self.selfMaterial )
	render.DrawSprite( pos, 1 * 23, 3.31579 * 23, Color(255, 255, 255))
end