extends Node2D

@onready var level_stage = StageManager.currentStage

# Called when the node enters the scene tree for the first time.
func _ready():
	Data.listen(self, "monsters.wavepresent")
	StageManager.stage_started.connect(stage_changed)
	
func propertyChanged(property : String, old_value, new_value):
	match property:
		"monsters.wavepresent":
			if !new_value:
				wave_ended()

func stage_changed():
	if StageManager.currentStage.name != "LevelStage":
		queue_free()
		
func wave_ended():
	var cycle = Data.ofOr("monsters.cycle", 0)
	
	#if cycle % 7 == 4 :
		#generate_bad_choice()
	if cycle % 3 == 1 :
		generate_choice(CONST.GADGET)
	elif cycle % 3 == 2: 
		generate_choice(CONST.POWERCORE)
	else :
		generate_choice("resources")


func generate_bad_choice():
	pass
	
func generate_choice(type):
	var i = preload("res://stages/level/GadgetChoiceInputProcessor.gd").new()
	i.popup = preload("res://mods-unpacked/POModder-EndlessCombatMode/content/Popups/Gadget_Popup.tscn").instantiate()
	level_stage.showPopup(i.popup)
	
	match type:
		CONST.GADGET:
			i.popup.loadGadgets()
		CONST.POWERCORE:
			i.popup.loadSupplements()
		"resources":
			i.popup.loadResources()
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


