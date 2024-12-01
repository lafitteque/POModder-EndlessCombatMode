extends Node2D

var id = "endlesscombat"
var modes = [CONST.MODE_PRESTIGE_MINER, CONST.MODE_PRESTIGE_PROVOCATION]
var selectedMode = modes[0]
var rerollsCount = 1

var modeContainer
var rerollContainer

@onready var mod_main = ModLoader.find_child("POModder-EndlessCombatMode",true,false)

func initialize_from_loadout(loadout_scene) -> void:
	pass


func generate_ui_block(loadout_scene) -> Node:
	var ui = preload("res://mods-unpacked/POModder-EndlessCombatMode/content/loadout_gamemode/BlockEndlessCombat.tscn").instantiate()
	modeContainer = ui.find_child("ModeContainer",true,false)
	rerollContainer = ui.find_child("RerollsContainer",true,false)
	for i in 2:
		var e = preload("res://stages/loadout/LoadoutChoice.tscn").instantiate()
		e.loadoutScale = 2.0
		var modeName = "loadout.endlesscombat." + modes[i]
		var desc = modeName + ".description"
		var id = str(modes[i])
		e.setChoice(modeName, id , Texture2D.new(), "")
		modeContainer.add_child(e)
		e.select.connect(modeSelected.bind(modes[i]))
		e.connect("select", loadout_scene.updateBlockVisibility)
		if i == 0 :
			e.selected = true
	for i in 4:
		var e = preload("res://stages/loadout/LoadoutChoice.tscn").instantiate()
		e.loadoutScale = 2.0
		var desc = str(i)
		var rerollName = "loadout.endlesscombat.rerollname"
		var id = str(i)
		e.setChoice(rerollName, id, Texture2D.new(), desc)
		rerollContainer.add_child(e)
		e.select.connect(rerollSelected.bind(i))
		e.connect("select", loadout_scene.updateBlockVisibility)
		if i == 1 :
			e.selected = true
		
	
	return ui
	
	
func has_difficulties() -> bool:
	return false


func has_map_sizes() -> bool:
	return false
	
	
func get_block_ui_name() -> String:
	return "BlockEndlessCombatLoadout"


func has_tiledata() -> bool:
	return true


func get_tiledata_name() -> String:
	return "endlesscombat"

	
func get_loadout_tiledata(stack_name : String) -> MapData:
	return preload("res://stages/loadout/TileDataModeRelicHunt.tscn").instantiate()

	
func get_loadout_tiledata_offset(stack_name : String) -> Vector2:
	return Vector2(-9, 2)

	
func set_gamemode_loadout(loadout_scene) -> void:
	var endlesscombat_loadout = GameWorld.lastLoadoutsByMode.get("prestige").duplicate()
	endlesscombat_loadout.difficulty = 0
	endlesscombat_loadout.modeId = id
	endlesscombat_loadout.worldId = GameWorld.getNextRandomWorldId()
	loadout_scene.setLoadout(endlesscombat_loadout)
	Level.loadout.difficulty = 0


func modeSelected(mode):
	selectedMode = mode
	for c in modeContainer.get_children():
		if not c is Label:
			c.selected = c.id == mode
	mod_main.mode = mode
	
func rerollSelected(i : int):
	rerollsCount = i	
	mod_main.rerollCount = i
	for c in rerollContainer.get_children():
		if not c is Label:
			c.selected = c.id == str(i)
	
func level_ready():
	if Level.loadout.modeId != "endlesscombat":
		return
		#
	#match selectedMode:
		#CONST.MODE_PRESTIGE_MINER:
			#Data.apply("prestige.baseperwave", 1)
		#CONST.MODE_PRESTIGE_PROVOCATION:
			#Data.apply("prestige.baseperwave", 100)
