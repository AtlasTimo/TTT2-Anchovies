include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

--[[function ENT:Initialize()
	timer.Simple(9,function()
		local spriteent = ents.Create("ent_spongebob_anchovies_anchovie")
		local pos,material = self.Entity:GetPos() + Vector(0, 2, 0), Material( "spongebob_anchovies/spongebob_anchovies_anchovie_mats/anchovie_1.png" )
		hook.Add( "HUDPaint", "paintsprites", function()
		cam.Start3D()
			render.SetMaterial( material )
			render.DrawSprite( pos, 1 * 25, 3.31579 * 25, color_white)
		cam.End3D()
		end )
	end)
end]]