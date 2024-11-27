extends Node

const MYMODNAME_LOG = "POModder-EndlessCombatMode"
const MYMODNAME_MOD_DIR = "POModder-EndlessCombatMode/"

var dir = ""
var ext_dir = ""

var trans_dir = "res://mods-unpacked/POModder-EndlessCombatMode/translations/"

func _init():
	ModLoaderLog.info("Init", MYMODNAME_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	ext_dir = dir + "extensions/"
	
	# Add extensions
	for loc in ["en" , "es" , "fr"]:
		ModLoaderMod.add_translation(trans_dir + "translations." + loc + ".translation")

	
func _ready():
	ModLoaderLog.info("Done", MYMODNAME_LOG)
	add_to_group("mod_init")

		
func modInit():
	manage_overrides()
	
	StageManager.connect("level_ready", _on_level_ready)

	var endlesscombat_loadout = preload("res://mods-unpacked/POModder-EndlessCombatMode/content/loadout_gamemode/Loadout_EndlessCombatMode.tscn").instantiate()
	add_child(endlesscombat_loadout)
	
	Data.registerGameMode("endlesscombat")
	GameWorld.unlockElement("endlesscombat")

	var endlessCombatPrepare = preload("res://mods-unpacked/POModder-EndlessCombatMode/content/gamemode_prepare/endlesscombat_prepare.tscn").instantiate()
	add_child(endlessCombatPrepare)
	
# Called when the node enters the scene tree for the first time.
func manage_overrides():
	### Adding new map archetype for custom Game Mode
	
	var new_archetype = preload("res://mods-unpacked/POModder-EndlessCombatMode/overrides/endlesscombat.tres")
	new_archetype.take_over_path("res://content/map/generation/archetypes/endlesscombat.tres")
	

	### Custom Game Mode (simply a copy of relichunt) :
	
	var endlesscombat = preload("res://content/gamemode/relichunt/Relichunt.tscn")
	endlesscombat.take_over_path("res://content/gamemode/endlesscombat/Endlesscombat.tscn")
	
	
	### Endless Combat Mode Icon
	
	#var coresaver_icon = preload("res://mods-unpacked/POModder-EndlessCombatMode/images/icon.png")
	#coresaver_icon.take_over_path("res://content/icons/loadout_endlesscombat.png")
	
	
func _on_level_ready():
	pass
	# ajouter le worldmodifier?


