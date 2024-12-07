extends Node2D

var exclude = ["furnace", "extractor",
 "blastMining", "probe", "teleporter", "lift",
 "condenser", "prospectionmeter", "suitblaster", 
"drill", "drillbot", "converter", "stationextension",
"mushroomfarm", "resourcepacker", "blastmining", "keeperonewayteleporter",
 "shredgadgettoiron", "shredgadgettocobalt", "shredgadgettowater"]
var cycle = -1
var rerollCount = 1

var mode

@onready var level_stage = StageManager.currentStage


# Called when the node enters the scene tree for the first time.
func _ready():
	Data.listen(self, "monsters.wavepresent")
	StageManager.stage_started.connect(stage_changed)
	
func setRerollCount(i : int):
	rerollCount = i
	
func setMode(modeName):
	mode = modeName
	
func propertyChanged(property : String, old_value, new_value):
	match property:
		"monsters.wavepresent":
			if !new_value:
				wave_ended()

func stage_changed():
	if StageManager.currentStage.name != "LevelStage":
		queue_free()
		
func wave_ended():
	Data.apply("monsters.waveCooldown", 3)
	cycle += 1
	
	if cycle == 0 :
		return
	
	var offer_valid = false
	#if cycle % 7 == 4 :
		#generate_bad_choice()
	if cycle % 3 == 1 :
		if GameWorld.generateGadgets(exclude.duplicate()).size() > 0:
			generate_choice(CONST.GADGET)
			offer_valid = true
	elif cycle % 3 == 2: 
		if GameWorld.generateSupplements(exclude.duplicate()).size() > 0:
			generate_choice(CONST.POWERCORE)
			offer_valid = true
			
	if ! offer_valid:
		generate_choice("resources")
		
	

func generate_bad_choice():
	pass
	
func generate_choice(type):
	var i = preload("res://stages/level/GadgetChoiceInputProcessor.gd").new()
	i.popup = preload("res://mods-unpacked/POModder-EndlessCombatMode/content/Popups/Gadget_Popup.tscn").instantiate()
	i.popup.maxRerollCount = rerollCount
	
	level_stage.showPopup(i.popup)
	
	match type:
		CONST.GADGET:
			i.popup.loadGadgets()
		CONST.POWERCORE:
			i.popup.loadSupplements()
		"resources":
			i.popup.loadResources()
			i.popup.maxRerollCount = 0
		_:
			Logger.error("unknown gadget type", "LevelStage.startGadgetChoiceInput", {"type": type})
			i.popup.queue_free()
			return
	
	i.connect("onStop", level_stage.unpause)
	i.connect("onStop", set.bind("inputDeviceLimit", -1))
	i.connect("deviceLocked", set)
	i.connect("dropsSelected", level_stage.addDropsToDome)
	i.connect("gadgetSelected", GameWorld.addUpgrade)
	i.integrate(self)
	level_stage.pause()




