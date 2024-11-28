extends "res://stages/level/GadgetChoicePopup.gd"

var exclude_gadgets = ["furnace", "extractor",
 "blastMining", "probe", "teleporter", "lift",
 "condenser", "prospectionmeter", "suitblaster", 
"drill", "drillbot", "converter", "stationextension",
"mushroomfarm", "resourcepacker", "blastmining"]
var exclude_powercore = ["furnace", "extractor",
 "blastMining", "probe", "teleporter", "lift",
 "condenser", "prospectionmeter", "suitblaster", 
"drill", "drillbot", "converter", "stationextension",
"mushroomfarm", "resourcepacker", "blastmining"]
var resource_offers = [
	{"id": "shredgadgettocobalt", 
	"dropType": CONST.SAND, 
	"amount": floor(1* clamp(Data.ofOr("monsters.cycle", 1)**(0.3) ,1,2) )
	},
	{"id": "shredgadgettoiron", 
	"dropType": CONST.IRON, 
	"amount": floor(clamp(6* Data.ofOr("monsters.cycle", 1)/2**(0.2) ,6,15) )
	},
	{"id": "shredgadgettowater", 
	"dropType": CONST.WATER, 
	"amount": floor(1* clamp(Data.ofOr("monsters.cycle", 1)**(0.4) ,1,4) )
	}]
	
func _ready():
	super()
	Data.apply("gadgetselection.paidreroll", false) 
	for x in gadgets:
		if not x.has("dropType"):
			# don't consider drop type offers here
			exclude_gadgets.append(x.id)
			exclude_powercore.append(x.id)
			
func loadResources():
	droptype = "resources"
	%TitleLabel.text = tr("level.supplementchoice.title")
	generateOffers()
		
func should_allow_reroll() -> bool:
	return true #rerollCount == 0


func generateOffers():
	var offer:Array
	var goalCount : int
	
	if droptype == CONST.POWERCORE:
		offer = GameWorld.generateSupplements(exclude_powercore.duplicate())
	elif droptype == CONST.GADGET:
		offer = GameWorld.generateGadgets(exclude_gadgets.duplicate())
	elif droptype == "resources":
		offer = resource_offers.duplicate()
	goalCount = min(offer.size(),4)
	
	
	var freeReroll = rerollCount == 0 
	var rerollPossible = freeReroll and offer.size() > goalCount

	%RerollButton.visible = rerollPossible
	if freeReroll:
		%RerollButton.icon = null

	for c in %Gadgets.get_children():
		%Gadgets.remove_child(c)
		c.queue_free()
	
	offer.resize(min(goalCount, offer.size()))
	
	var count = offer.size()
	self.gadgets = offer
	
	find_child("Gadgets").columns = 2
	
	for g in gadgets:
		var id = g.get("id", "missing_id")
		var choice
		if Data.supplements.has(id):
			choice = preload("res://stages/level/SupplementChoice.tscn").instantiate()
			choice.fillSupplement(g)
		else:
			choice = preload("res://stages/level/GadgetChoice.tscn").instantiate()
			choice.fillGadget(g)
		if g.has("dropType") and g["dropType"] == CONST.IRON:

			var icon = choice.find_child("IconTextureRect")
			icon.position -= icon.size * 0.25
			icon.custom_minimum_size = Vector2i(10,10)
			icon.scale = Vector2(0.5,0.5)
			
		%Gadgets.add_child(choice)
		choice.connect("focussed", optionFocussed.bind(g, choice))
		choice.connect("selected", emit_signal.bind("selected_by_mouse"))
	
	InputSystem.grabFocus(%Gadgets.get_children().front())


