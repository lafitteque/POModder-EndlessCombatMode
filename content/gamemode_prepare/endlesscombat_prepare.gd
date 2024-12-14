extends Node2D

func prepareGameMode(modeId, levelStartData):
	print("Game mode prepare :" , modeId)
	if modeId != "endlesscombat":
		return
		
	levelStartData.loadout.modeConfig[CONST.MODE_CONFIG_WORLDMODIFIERS] =  ["worldmodifiernorelic"]
	levelStartData.loadout.modeConfig["upgradelimits"] = ["hostile"]
	GameWorld.setUpgradeLimitAvailable("hostile")
	
	levelStartData.mapArchetype = load("res://mods-unpacked/POModder-EndlessCombatMode/overrides/endlesscombat.tres").duplicate()
	levelStartData.mapArchetype.cobalt_rate = 0.0

	if not levelStartData.loadout.worldId or levelStartData.loadout.worldId == "":
		levelStartData.loadout.worldId = GameWorld.getNextRandomWorldId()
	Data.apply("monsters.allowedtypes", Data.gameProperties.get("monstersbyworld.world6"))
	
	GameWorld.removeAvailableUpgradeLimit("mining")
	
	for modifierId in levelStartData.loadout.modeConfig.get(CONST.MODE_CONFIG_WORLDMODIFIERS, []):
		if ! Data.worldModifiers.has(modifierId) :
			continue
		var modifier = Data.worldModifiers[modifierId]
		for propertyChange in modifier.get("propertychanges", {}):
			if levelStartData.mapArchetype and propertyChange.keyClass == "archetype":
				if propertyChange.value is String and  propertyChange.value.begins_with("res://"):
					levelStartData.mapArchetype.set(propertyChange.keyName, load(propertyChange.value))
				else:
					var oldValue =  levelStartData.mapArchetype.get(propertyChange.keyName)
					var newValue = propertyChange.getChangedValue(oldValue)
					levelStartData.mapArchetype.set(propertyChange.keyName, newValue)
			else:
				Data.applyPropertyChange(propertyChange)
		for slot in modifier.get("addslots", []):
			GameWorld.availableTechSlots.append(slot)
		for limit in modifier.get("upgradelimits", []):
			GameWorld.setUpgradeLimitAvailable(limit)
		for eraseLimit in modifier.get("eraseupgradelimits", []):
			GameWorld.removeAvailableUpgradeLimit(eraseLimit)
		var globalAreaOverrides = modifier.get("globalareaoverrides", {})
		for areaOverride in globalAreaOverrides:
			levelStartData.loadout.globalAreaOverrides[areaOverride] = globalAreaOverrides[areaOverride]
