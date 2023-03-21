SPONGEBOB_ANCHOVIES = SPONGEBOB_ANCHOVIES or {}
SPONGEBOB_ANCHOVIES.CVARS = SPONGEBOB_ANCHOVIES.CVARS or {}
--test
local use_german_sound = CreateConVar("ttt_spongebobanchovies_use_german_sound", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local use_alt_sound_only = CreateConVar("ttt_spongebobanchovies_use_only_alt_sound", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local use_max_hits = CreateConVar("ttt_spongebobanchovies_activate_max_hits", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local anchovies_amount = CreateConVar("ttt_spongebobanchovies_anchovies_amount", "50", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local anchovies_sighting_range = CreateConVar("ttt_spongebobanchovies_anchovies_sighting_range", "450", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local anchovies_patrol_speed = CreateConVar("ttt_spongebobanchovies_anchovies_patrol_speed", "8", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local anchovies_target_speed = CreateConVar("ttt_spongebobanchovies_anchovies_target_speed", "11", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local anchovies_bus_speed = CreateConVar("ttt_spongebobanchovies_anchovies_bus_speed", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local anchovies_bus_damage = CreateConVar("ttt_spongebobanchovies_anchovies_bus_damage", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local anchovies_hit_player_damage = CreateConVar("ttt_spongebobanchovies_anchovies_hit_player_damage", "100", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local anchovies_not_hit_player_damage = CreateConVar("ttt_spongebobanchovies_anchovies_not_hit_player_damage", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local anchovies_max_hits = CreateConVar("ttt_spongebobanchovies_anchovies_max_hits", "3", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})

SPONGEBOB_ANCHOVIES.CVARS.use_german_sound = use_german_sound:GetBool()
SPONGEBOB_ANCHOVIES.CVARS.use_alt_sound_only = use_alt_sound_only:GetBool()
SPONGEBOB_ANCHOVIES.CVARS.use_max_hits = use_max_hits:GetBool()
SPONGEBOB_ANCHOVIES.CVARS.anchovies_amount = anchovies_amount:GetInt()
SPONGEBOB_ANCHOVIES.CVARS.anchovies_sighting_range = anchovies_sighting_range:GetInt()
SPONGEBOB_ANCHOVIES.CVARS.anchovies_patrol_speed = anchovies_patrol_speed:GetInt()
SPONGEBOB_ANCHOVIES.CVARS.anchovies_target_speed = anchovies_target_speed:GetInt()
SPONGEBOB_ANCHOVIES.CVARS.anchovies_bus_speed = anchovies_bus_speed:GetInt()
SPONGEBOB_ANCHOVIES.CVARS.anchovies_bus_damage = anchovies_bus_damage:GetInt()
SPONGEBOB_ANCHOVIES.CVARS.anchovies_hit_player_damage = anchovies_hit_player_damage:GetInt()
SPONGEBOB_ANCHOVIES.CVARS.anchovies_not_hit_player_damage = anchovies_not_hit_player_damage:GetInt()
SPONGEBOB_ANCHOVIES.CVARS.anchovies_max_hits = anchovies_max_hits:GetInt()

if SERVER then
  cvars.AddChangeCallback("ttt_spongebobanchovies_use_german_sound", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.use_german_sound = util.StringToType(new, "bool")
  end, nil)

  cvars.AddChangeCallback("ttt_spongebobanchovies_use_only_alt_sound", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.use_alt_sound_only = util.StringToType(new, "bool")
  end, nil)

  cvars.AddChangeCallback("ttt_spongebobanchovies_activate_max_hits", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.use_max_hits = util.StringToType(new, "bool")
  end, nil)

  cvars.AddChangeCallback("ttt_spongebobanchovies_anchovies_amount", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.anchovies_amount = tonumber(new)
  end, nil)

  cvars.AddChangeCallback("ttt_spongebobanchovies_anchovies_sighting_range", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.anchovies_sighting_range = tonumber(new)
  end, nil)

  cvars.AddChangeCallback("ttt_spongebobanchovies_anchovies_patrol_speed", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.anchovies_patrol_speed = tonumber(new)
  end, nil)
  
  cvars.AddChangeCallback("ttt_spongebobanchovies_anchovies_target_speed", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.anchovies_target_speed = tonumber(new)
  end, nil)

  cvars.AddChangeCallback("ttt_spongebobanchovies_anchovies_bus_speed", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.anchovies_bus_speed = tonumber(new)
  end, nil)

  cvars.AddChangeCallback("ttt_spongebobanchovies_anchovies_bus_damage", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.anchovies_bus_damage = tonumber(new)
  end, nil)

  cvars.AddChangeCallback("ttt_spongebobanchovies_anchovies_hit_player_damage", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.anchovies_hit_player_damage = tonumber(new)
  end, nil)

  cvars.AddChangeCallback("ttt_spongebobanchovies_anchovies_not_hit_player_damage", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.anchovies_not_hit_player_damage = tonumber(new)
  end, nil)

  cvars.AddChangeCallback("ttt_spongebobanchovies_anchovies_max_hits", function(name, old, new)
    SPONGEBOB_ANCHOVIES.CVARS.anchovies_max_hits = tonumber(new)
  end, nil)
end
