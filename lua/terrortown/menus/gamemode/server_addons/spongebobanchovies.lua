CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_addons_spongebobanchovies_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "help_spongebobanchovies_general_settings")

	form:MakeCheckBox({
		label = "label_spongebobanchovies_use_german_sound",
		serverConvar = "ttt_spongebobanchovies_use_german_sound"
	})

	form:MakeCheckBox({
		label = "label_spongebobanchovies_use_only_alt_sound",
		serverConvar = "ttt_spongebobanchovies_use_only_alt_sound"
	})

	local form2 = vgui.CreateTTT2Form(parent, "help_spongebobanchovies_bus_settings")

	form2:MakeSlider({
		label = "label_spongebobanchovies_anchovies_bus_speed",
		serverConvar = "ttt_spongebobanchovies_anchovies_bus_speed",
		min = 4,
		max = 15,
		decimal = 0
	})

	form2:MakeSlider({
		label = "label_spongebobanchovies_anchovies_bus_damage",
		serverConvar = "ttt_spongebobanchovies_anchovies_bus_damage",
		min = 1,
		max = 200,
		decimal = 0
	})

	local form3 = vgui.CreateTTT2Form(parent, "help_spongebobanchovies_anchovie_settings")

	form3:MakeSlider({
		label = "label_spongebobanchovies_anchovies_amount",
		serverConvar = "ttt_spongebobanchovies_anchovies_amount",
		min = 10,
		max = 100,
		decimal = 0
	})

	form3:MakeSlider({
		label = "label_spongebobanchovies_anchovies_target_speed",
		serverConvar = "ttt_spongebobanchovies_anchovies_target_speed",
		min = 5,
		max = 30,
		decimal = 0
	})

	form3:MakeSlider({
		label = "label_spongebobanchovies_anchovies_patrol_speed",
		serverConvar = "ttt_spongebobanchovies_anchovies_patrol_speed",
		min = 5,
		max = 30,
		decimal = 0
	})

	form3:MakeCheckBox({
		label = "label_spongebobanchovies_activate_max_hits",
		serverConvar = "ttt_spongebobanchovies_activate_max_hits"
	})

	form3:MakeSlider({
		label = "label_spongebobanchovies_anchovies_max_hits",
		serverConvar = "ttt_spongebobanchovies_anchovies_max_hits",
		min = 1,
		max = 10,
		decimal = 0
	})

	form3:MakeSlider({
		label = "label_spongebobanchovies_anchovies_sighting_range",
		serverConvar = "ttt_spongebobanchovies_anchovies_sighting_range",
		min = 10,
		max = 2000,
		decimal = 0
	})

	form3:MakeSlider({
		label = "label_spongebobanchovies_anchovies_hit_player_damage",
		serverConvar = "ttt_spongebobanchovies_anchovies_hit_player_damage",
		min = 1,
		max = 200,
		decimal = 0
	})

	form3:MakeSlider({
		label = "label_spongebobanchovies_anchovies_not_hit_player_damage",
		serverConvar = "ttt_spongebobanchovies_anchovies_not_hit_player_damage",
		min = 1,
		max = 200,
		decimal = 0
	})
end
