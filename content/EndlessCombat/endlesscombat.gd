extends "res://content/gamemode/relichunt/Relichunt.gd"

@onready var mod_main = ModLoader.find_child("POModder-EndlessCombatMode",true,false)

func init():
	super()
	
func _process(delta):
	super(delta)
	
	

func getRunWeight() -> float:
	if mod_main.mode == CONST.MODE_PRESTIGE_MINER:
		return 0.0
	
	var weight := 0.0
	var cycle = Data.of("monsters.cycle")
	
	weight += round(pow(2, ((cycle - (1 + Level.loadout.difficulty)) * 0.08)) * cycle * 10 + cycle * 10)
	weight += GameWorld.additionalRunWeight
	weight += Data.of("prestige.provokedwavestrengthadditive")
	weight *= Data.of("prestige.provokedwavestrength")
	weight *= Data.of("monstermodifiers.totalrunweightmodifier")
	weight *= 1.0 + Level.loadout.difficulty * 0.1
	
	return max(15, weight)
