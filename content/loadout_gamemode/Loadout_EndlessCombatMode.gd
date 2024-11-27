extends Node2D

var id = "endlesscombat"

func initialize_from_loadout(loadout_scene):
	return null

func generate_ui_block(loadout_scene):
	return preload("res://mods-unpacked/POModder-EndlessCombatMode/content/loadout_gamemode/BlockEndlessCombat.tscn").instantiate()
	
func has_difficulties():
	return false

func has_map_sizes():
	return false
	
func get_block_ui_name():
	return "BlockEndlessCombatLoadout"

func has_tiledata():
	return true

func get_tiledata_name():
	return "endlesscombat"
	
func get_loadout_tiledata(stack_name : String):
	return preload("res://stages/loadout/TileDataModeRelicHunt.tscn").instantiate()

	
func get_loadout_tiledata_offset(stack_name : String):
	return Vector2(-9, 2)
	
func set_gamemode_loadout(loadout_scene):
	var coresaver_loadout = GameWorld.lastLoadoutsByMode.get("relichunt").duplicate()
	coresaver_loadout.difficulty = 3
	coresaver_loadout.modeId = id
	coresaver_loadout.worldId = GameWorld.getNextRandomWorldId()
	loadout_scene.setLoadout(coresaver_loadout)

