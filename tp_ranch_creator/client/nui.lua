
local PlayerData = {
	HasNUIActive    = false,
	IsBusy          = false,
	HasNUIHidden    = false,
	HasCooldown     = false,
	SelectedRanchId = 0,
}

local CURRENT_LOADED_DATA_COUNT = 0

ENTITIES_CONFIG_DATA = {}
TOTAL_HERDING_SPAWN_POINTS = {}
TOTAL_HERDING_POINTS = {}
TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS = {}
---------------------------------------------------------------
--[[ Local Functions ]]--
---------------------------------------------------------------

local function ToggleUI (display, window)

    PlayerData.HasNUIActive = display

    SetNuiFocus(display, display)

    if not display then
        DisplayRadar(true)
        SetNuiFocus(false, false)

		ClearPlacedRanchObjectsList()

		ENTITIES_CONFIG_DATA = nil
		ENTITIES_CONFIG_DATA = {}

		TriggerEvent("tp_ranch_creator:client:has_active_editor", false)

	else
		PlayerData.HasNUIHidden = false
		PlayerData.IsBusy = false
	end

    SendNUIMessage({ type = "enable", enable = display, window = window })
end

local function tableToLua(tbl)

	if type(tbl) ~= "table" then
        return 'n/a'
    end
	
    local order = {
        "model",
        "skin_preset",
        "x",
        "y",
        "z",
        "h",
        "pitch",
        "roll",
        "yaw",
        "icon",
        "adjust_icon_height",
        "marker",
        "marker_xy",
        "marker_rgba",
        "adjust_marker_height",
        "action_distance",
    }

    local function valueToLua(value)
        local valueType = type(value)

        if valueType == "string" then
            return string.format("%q", value)
        elseif valueType == "boolean" then
            return value and "true" or "false"
        elseif valueType == "number" then
            return tostring(value)
        elseif valueType == "table" then
            return tableToLua(value)
        elseif valueType == "nil" then
            return "nil"
        else
            return tostring(value)
        end
    end

    local parts = {}
    local used = {}

    -- Write keys in the preferred order
    for _, key in ipairs(order) do
        if tbl[key] ~= nil then
            table.insert(parts, ("%s = %s"):format(key, valueToLua(tbl[key])))
            used[key] = true
        end
    end

    -- Write any remaining keys
    for key, value in pairs(tbl) do
        if not used[key] then
            table.insert(parts, ("%s = %s"):format(key, valueToLua(value)))
        end
    end

    return "{ " .. table.concat(parts, ", ") .. " }"
end

local function tablesEqual(a, b)
    if a == b then
        return true
    end

    if type(a) ~= "table" or type(b) ~= "table" then
        return false
    end

    for k, v in pairs(a) do
        if type(v) == "table" then
            if not tablesEqual(v, b[k]) then
                return false
            end
        elseif b[k] ~= v then
            return false
        end
    end

    for k in pairs(b) do
        if a[k] == nil then
            return false
        end
    end

    return true
end

---------------------------------------------------------------
--[[ Functions ]]--
---------------------------------------------------------------

function GetPlayerData()
	return PlayerData
end

function OpenRanchCreator(ranchId)

	if PlayerData.HasNUIActive then 
		return
	end

	TriggerEvent("tp_ranch_creator:client:has_active_editor", true)
	
	SendNUIMessage({ action = 'insertLocales', locales = Locales })

	PlayerData.SelectedRanchId = 0

	if ranchId then 
		PlayerData.SelectedRanchId = tonumber(ranchId)
	end

	ENTITIES_CONFIG_DATA = {}
	TOTAL_HERDING_SPAWN_POINTS = {}
	TOTAL_HERDING_POINTS = {}
	TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS = {}
	PLACED_RANCH_ENTITIES = {}

	if ranchId ~= nil and ranchId ~= 0 then 

		local getRanchData = exports.tp_libs:ClientRpcCall().Callback.TriggerAwait("tp_ranch_creator:callbacks:getRanchDataById", { ranchId = ranchId } )

		if getRanchData == nil then
			-- notify does not exist
			TriggerEvent("tp_ranch_creator:client:has_active_editor", false)
			print('Attempted to edit a non-existing ranch with the id: ' .. ranchId .. ' - the ranch must exist on tp_ranch config.')
			return
		end

		TOTAL_HERDING_SPAWN_POINTS = getRanchData.Herding.SpawnPoints
		TOTAL_HERDING_POINTS       = getRanchData.Herding.HerdingPoints
		TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS = getRanchData.Herding.WolfAttack.SpawnPoints

		SendNUIMessage({ 
			action = 'setExistingDataBasics', 
			result = getRanchData,
			ranchId = ranchId,
		})

		SendNUIMessage({ 
			action = 'setHerdingExistingData', 
			wolf_data = getRanchData.Herding.WolfAttack
		})

		-- Load milk jug object

		if getRanchData.MilkContainerCoords then
			LoadModel('p_milkcan01x')

			local milk_jug = CreateObject(GetHashKey('p_milkcan01x'), getRanchData.MilkContainerCoords.x, getRanchData.MilkContainerCoords.y, getRanchData.MilkContainerCoords.z, false, false, false, false, false)
			
			SetEntityVisible(milk_jug, true)
			SetEntityCollision(milk_jug, true)
			SetEntityRotation(milk_jug, getRanchData.MilkContainerCoords.pitch, getRanchData.MilkContainerCoords.roll, getRanchData.MilkContainerCoords.yaw, 2)
			SetEntityCoords(milk_jug, getRanchData.MilkContainerCoords.x, getRanchData.MilkContainerCoords.y, getRanchData.MilkContainerCoords.z)
	
			PLACED_RANCH_ENTITIES['MILK_CONTAINER_1'] = { entity = milk_jug, is_object = true, model = 'p_milkcan01x', coords = getRanchData.MilkContainerCoords, pitch = getRanchData.MilkContainerCoords.pitch, roll = getRanchData.MilkContainerCoords.roll, yaw = getRanchData.MilkContainerCoords.yaw}
		
		end

		if getRanchData.WaterBarrelCoords then
			LoadModel('p_barrelhalf02x')

			local water_barrel = CreateObject(GetHashKey('p_barrelhalf02x'), getRanchData.WaterBarrelCoords.x, getRanchData.WaterBarrelCoords.y, getRanchData.WaterBarrelCoords.z, false, false, false, false, false)
			
			SetEntityVisible(water_barrel, true)
			SetEntityCollision(water_barrel, true)
			SetEntityRotation(water_barrel, getRanchData.WaterBarrelCoords.pitch, getRanchData.WaterBarrelCoords.roll, getRanchData.WaterBarrelCoords.yaw, 2)
			SetEntityCoords(water_barrel, getRanchData.WaterBarrelCoords.x, getRanchData.WaterBarrelCoords.y, getRanchData.WaterBarrelCoords.z)
	
			PLACED_RANCH_ENTITIES['WATER_BARREL'] = { entity = water_barrel, is_object = true, model = 'p_barrelhalf02x', coords = getRanchData.WaterBarrelCoords, pitch = getRanchData.WaterBarrelCoords.pitch, roll = getRanchData.WaterBarrelCoords.roll, yaw = getRanchData.WaterBarrelCoords.yaw}

		end

		if getRanchData.PitchForkObjectCoords then
			LoadModel('p_pitchfork01x')

			local pitchfork = CreateObject(GetHashKey('p_pitchfork01x'), getRanchData.PitchForkObjectCoords.x, getRanchData.PitchForkObjectCoords.y, getRanchData.PitchForkObjectCoords.z, false, false, false, false, false)
			
			SetEntityVisible(pitchfork, true)
			SetEntityCollision(pitchfork, true)
			SetEntityRotation(pitchfork, getRanchData.PitchForkObjectCoords.pitch, getRanchData.PitchForkObjectCoords.roll, getRanchData.PitchForkObjectCoords.yaw, 2)
			SetEntityCoords(pitchfork, getRanchData.PitchForkObjectCoords.x, getRanchData.PitchForkObjectCoords.y, getRanchData.PitchForkObjectCoords.z)
	
			PLACED_RANCH_ENTITIES['PITCH_FORK'] = { entity = pitchfork, is_object = true, model = 'p_pitchfork01x', coords = getRanchData.PitchForkObjectCoords, pitch = getRanchData.PitchForkObjectCoords.pitch, roll = getRanchData.PitchForkObjectCoords.roll, yaw = getRanchData.PitchForkObjectCoords.yaw}

		end

		if getRanchData.CauldronObject then
			LoadModel(getRanchData.CauldronObject.object)

			local cauldron = CreateObject(GetHashKey(getRanchData.CauldronObject.object), getRanchData.CauldronObject.x, getRanchData.CauldronObject.y, getRanchData.CauldronObject.z, false, false, false, false, false)
			
			SetEntityVisible(cauldron, true)
			SetEntityCollision(cauldron, true)
			SetEntityRotation(cauldron, getRanchData.CauldronObject.pitch, getRanchData.CauldronObject.roll, getRanchData.CauldronObject.yaw, 2)
			SetEntityCoords(cauldron, getRanchData.CauldronObject.x, getRanchData.CauldronObject.y, getRanchData.CauldronObject.z)
	
			PLACED_RANCH_ENTITIES['CAULDRON_1'] = { entity = cauldron, is_object = true, model = getRanchData.CauldronObject.object, coords = getRanchData.CauldronObject, pitch = getRanchData.CauldronObject.pitch, roll = getRanchData.CauldronObject.roll, yaw = getRanchData.CauldronObject.yaw}

		end

		if ENTITIES_CONFIG_DATA['COW'] == nil then 
			ENTITIES_CONFIG_DATA['COW'] = {}

			ENTITIES_CONFIG_DATA['COW'].actions = {

				['SPAWN']   = getRanchData.Animals['a_c_cow'].SpawnCoords,
				['MILKING'] = getRanchData.Animals['a_c_cow'].StartMilkingCoords,
				['BUCKET']  = getRanchData.Animals['a_c_cow'].MilkBucketCoords,
				['POOP']    = getRanchData.Animals['a_c_cow'].PoopPositions,

			}

			ENTITIES_CONFIG_DATA['COW'].default_action = {}
			ENTITIES_CONFIG_DATA['COW'].count = getRanchData.Animals['a_c_cow'].Total

			ENTITIES_CONFIG_DATA['COW'].default_action['SPAWN'] = { x = 0, y = 0, z = 0 }
			ENTITIES_CONFIG_DATA['COW'].default_action['MILKING'] = { x = 0, y = 0, z = 0, h = 0}
			ENTITIES_CONFIG_DATA['COW'].default_action['BUCKET'] = { x = 0, y = 0, z = 0 }
			ENTITIES_CONFIG_DATA['COW'].default_action['POOP'] = { x = 0, y = 0, z = 0 }

			if GetTableLength(ENTITIES_CONFIG_DATA['COW'].actions['SPAWN']) > 0 then 

				for _, entity in pairs (ENTITIES_CONFIG_DATA['COW'].actions['SPAWN']) do 

					local model = 'a_c_cow'
					LoadModel(model)

					local _entity = CreatePed(GetHashKey(model), entity.x, entity.y, entity.z, entity.h, false, false, false, false )
	
					SetRandomOutfitVariation(_entity, true) -- set first outfit
					SetModelAsNoLongerNeeded(GetHashKey(model))
					SetEntityInvincible(_entity, true)
					SetEntityCanBeDamaged(_entity, false)
					SetEntityCollision(_entity, false)
					SetPedScale(_entity, 0.9)
					FreezeEntityPosition(_entity, true)
					SetEntityInvincible(_entity, true)
					SetEntityCanBeDamaged(_entity, false)
					SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(_entity), joaat('PLAYER'))

					PLACED_RANCH_ENTITIES['COW-SPAWN-' .. _] = { entity = _entity, is_object = false, model = model, coords = { x = entity.x, y = entity.y, z = entity.z, h = entity.h} }

				end

			end

			if GetTableLength(ENTITIES_CONFIG_DATA['COW'].actions['BUCKET']) > 0 then 

				for _, obj in pairs (ENTITIES_CONFIG_DATA['COW'].actions['BUCKET']) do 

					LoadModel( "s_bucketmilk01x" )
	
					local toVec  = vector3(obj.x, obj.y, obj.z)
					local object = CreateObject(GetHashKey('s_bucketmilk01x'), toVec, false, false, false, false, false)
				
					SetEntityVisible(object, true)
					SetEntityCollision(object, false)

					PLACED_RANCH_ENTITIES['COW-BUCKET-' .. _] = { entity = object, is_object = true, model = "s_bucketmilk01x", coords = { x = obj.x, y = obj.y, z = obj.z, h = obj.h} }
				end

			end


			if GetTableLength(ENTITIES_CONFIG_DATA['COW'].actions['POOP']) > 0 then 

				for _, obj in pairs (ENTITIES_CONFIG_DATA['COW'].actions['POOP']) do 

					LoadModel( "p_sheeppoop01x" )
	
					local toVec  = vector3(obj.x, obj.y, obj.z)
					local object = CreateObject(GetHashKey('p_sheeppoop01x'), toVec, false, false, false, false, false)
				
					SetEntityVisible(object, true)
					SetEntityCollision(object, true)
					FreezeEntityPosition(object, true)
					SetEntityFadeIn(object, true)

					PlaceObjectOnGroundProperly(object, true)

					PLACED_RANCH_ENTITIES['COW-POOP-' .. _] = { entity = object, is_object = true, model = "p_sheeppoop01x", coords = { x = obj.x, y = obj.y, z = obj.z, h = obj.h} }
				end

			end

			-- spawn animal, bucket, poop
		end

		if ENTITIES_CONFIG_DATA['GOAT'] == nil then 
			ENTITIES_CONFIG_DATA['GOAT'] = {}
			ENTITIES_CONFIG_DATA['GOAT'].actions = {

				['SPAWN']   = getRanchData.Animals['a_c_goat_01'].SpawnCoords,
				['MILKING'] = getRanchData.Animals['a_c_goat_01'].StartMilkingCoords,
				['BUCKET']  = getRanchData.Animals['a_c_goat_01'].MilkBucketCoords,
				['POOP']    = getRanchData.Animals['a_c_goat_01'].PoopPositions,

			}

			ENTITIES_CONFIG_DATA['GOAT'].default_action = {}
			ENTITIES_CONFIG_DATA['GOAT'].count = getRanchData.Animals['a_c_goat_01'].Total

			ENTITIES_CONFIG_DATA['GOAT'].default_action['SPAWN'] = { x = 0, y = 0, z = 0 }
			ENTITIES_CONFIG_DATA['GOAT'].default_action['MILKING'] = { x = 0, y = 0, z = 0, h = 0}
			ENTITIES_CONFIG_DATA['GOAT'].default_action['BUCKET'] = { x = 0, y = 0, z = 0 }
			ENTITIES_CONFIG_DATA['GOAT'].default_action['POOP'] = { x = 0, y = 0, z = 0 }

			-- spawn animal, bucket, poop

			if GetTableLength(ENTITIES_CONFIG_DATA['GOAT'].actions['SPAWN']) > 0 then 

				for _, entity in pairs (ENTITIES_CONFIG_DATA['GOAT'].actions['SPAWN']) do 

					local model = 'a_c_goat_01'
					LoadModel(model)

					local _entity = CreatePed(GetHashKey(model), entity.x, entity.y, entity.z, entity.h, false, false, false, false )
	
					SetRandomOutfitVariation(_entity, true) -- set first outfit
					SetModelAsNoLongerNeeded(GetHashKey(model))
					SetEntityInvincible(_entity, true)
					SetEntityCanBeDamaged(_entity, false)
					SetEntityCollision(_entity, false)
					SetPedScale(_entity, 0.9)
					FreezeEntityPosition(_entity, true)
					SetEntityInvincible(_entity, true)
					SetEntityCanBeDamaged(_entity, false)
					SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(_entity), joaat('PLAYER'))

					PLACED_RANCH_ENTITIES['GOAT-SPAWN-' .. _] = { entity = _entity, is_object = false, model = model, coords = { x = entity.x, y = entity.y, z = entity.z, h = entity.h} }

				end

			end

			if GetTableLength(ENTITIES_CONFIG_DATA['GOAT'].actions['BUCKET']) > 0 then 

				for _, obj in pairs (ENTITIES_CONFIG_DATA['GOAT'].actions['BUCKET']) do 

					LoadModel( "s_bucketmilk01x" )
	
					local toVec  = vector3(obj.x, obj.y, obj.z)
					local object = CreateObject(GetHashKey('s_bucketmilk01x'), toVec, false, false, false, false, false)
				
					SetEntityVisible(object, true)
					SetEntityCollision(object, false)

					PLACED_RANCH_ENTITIES['GOAT-BUCKET-' .. _] = { entity = object, is_object = true, model = "s_bucketmilk01x", coords = { x = obj.x, y = obj.y, z = obj.z, h = obj.h} }
				end

			end

			if GetTableLength(ENTITIES_CONFIG_DATA['GOAT'].actions['POOP']) > 0 then 

				for _, obj in pairs (ENTITIES_CONFIG_DATA['GOAT'].actions['POOP']) do 

					LoadModel( "p_sheeppoop01x" )
	
					local toVec  = vector3(obj.x, obj.y, obj.z)
					local object = CreateObject(GetHashKey('p_sheeppoop01x'), toVec, false, false, false, false, false)
				
					SetEntityVisible(object, true)
					SetEntityCollision(object, true)
					FreezeEntityPosition(object, true)
					SetEntityFadeIn(object, true)

					PlaceObjectOnGroundProperly(object, true)

					PLACED_RANCH_ENTITIES['GOAT-POOP-' .. _] = { entity = object, is_object = true, model = "p_sheeppoop01x", coords = { x = obj.x, y = obj.y, z = obj.z, h = obj.h} }
				end

			end
		end

		if ENTITIES_CONFIG_DATA['SHEEP'] == nil then 
			ENTITIES_CONFIG_DATA['SHEEP'] = {}

			ENTITIES_CONFIG_DATA['SHEEP'].actions = {
				['SPAWN']    = getRanchData.Animals['a_c_sheep_01'].SpawnCoords,
				['SHEARING'] = getRanchData.Animals['a_c_sheep_01'].TeleportPlayerShearingCoords,
				['POOP']     = getRanchData.Animals['a_c_sheep_01'].PoopPositions,
			}

			ENTITIES_CONFIG_DATA['SHEEP'].default_action = {}
			ENTITIES_CONFIG_DATA['SHEEP'].count = getRanchData.Animals['a_c_sheep_01'].Total

			ENTITIES_CONFIG_DATA['SHEEP'].default_action['SPAWN'] = { x = 0, y = 0, z = 0 }
			ENTITIES_CONFIG_DATA['SHEEP'].default_action['SHEARING'] = { x = 0, y = 0, z = 0, h = 0 }
			ENTITIES_CONFIG_DATA['SHEEP'].default_action['POOP'] = { x = 0, y = 0, z = 0 }

			-- spawn animal, poop

			if GetTableLength(ENTITIES_CONFIG_DATA['SHEEP'].actions['SPAWN']) > 0 then 

				for _, entity in pairs (ENTITIES_CONFIG_DATA['SHEEP'].actions['SPAWN']) do 

					local model = 'a_c_sheep_01'
					LoadModel(model)

					local _entity = CreatePed(GetHashKey(model), entity.x, entity.y, entity.z, entity.h, false, false, false, false )
	
					SetRandomOutfitVariation(_entity, true) -- set first outfit
					SetModelAsNoLongerNeeded(GetHashKey(model))
					SetEntityInvincible(_entity, true)
					SetEntityCanBeDamaged(_entity, false)
					SetEntityCollision(_entity, false)
					SetPedScale(_entity, 0.9)
					FreezeEntityPosition(_entity, true)
					SetEntityInvincible(_entity, true)
					SetEntityCanBeDamaged(_entity, false)
					SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(_entity), joaat('PLAYER'))

					PLACED_RANCH_ENTITIES['SHEEP-SPAWN-' .. _] = { entity = _entity, is_object = false, model = model, coords = { x = entity.x, y = entity.y, z = entity.z, h = entity.h} }

				end

			end

			if GetTableLength(ENTITIES_CONFIG_DATA['SHEEP'].actions['POOP']) > 0 then 

				for _, obj in pairs (ENTITIES_CONFIG_DATA['SHEEP'].actions['POOP']) do 

					LoadModel( "p_sheeppoop01x" )
	
					local toVec  = vector3(obj.x, obj.y, obj.z)
					local object = CreateObject(GetHashKey('p_sheeppoop01x'), toVec, false, false, false, false, false)
				
					SetEntityVisible(object, true)
					SetEntityCollision(object, true)
					FreezeEntityPosition(object, true)
					SetEntityFadeIn(object, true)

					PlaceObjectOnGroundProperly(object, true)

					PLACED_RANCH_ENTITIES['SHEEP-POOP-' .. _] = { entity = object, is_object = true, model = "p_sheeppoop01x", coords = { x = obj.x, y = obj.y, z = obj.z, h = obj.h} }
				end

			end

		end

		
		if ENTITIES_CONFIG_DATA['CHICKEN'] == nil then 

			ENTITIES_CONFIG_DATA['CHICKEN'] = {}

			ENTITIES_CONFIG_DATA['CHICKEN'].actions = {
				['SPAWN']     = getRanchData.Animals['a_c_chicken_01'].SpawnCoords,
				['EGG_SPAWN'] = getRanchData.Animals['a_c_chicken_01'].EggSpawnCoords,
				['FEEDBAG']   = {
					[1] = getRanchData.Animals['a_c_chicken_01'].FeedbagStandCoords,
				},
				['FEEDING']   = {
					[1] = getRanchData.Animals['a_c_chicken_01'].StartFeedingCoords,
				},
				['DELIVERY']  = {
					[1] = getRanchData.Animals['a_c_chicken_01'].ChickenFoodCoords,
				},
			}
			ENTITIES_CONFIG_DATA['CHICKEN'].default_action = {}
			ENTITIES_CONFIG_DATA['CHICKEN'].count = getRanchData.Animals['a_c_chicken_01'].Total

			ENTITIES_CONFIG_DATA['CHICKEN'].default_action['SPAWN'] = { x = 0, y = 0, z = 0 }
			ENTITIES_CONFIG_DATA['CHICKEN'].default_action['EGG_SPAWN'] = { x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0 }
		
			ENTITIES_CONFIG_DATA['CHICKEN'].default_action['FEEDBAG'] = {
				x = 0, 
				y = 0, 
				z = 0, 
				pitch = 0, 
				roll = 0,
				yaw = 0, 
				render_distance = 30.0,
	
				action_distance = 1.5,
				display_icon_distance = 5.0,
				adjust_icon_height = 2.0
			}

			ENTITIES_CONFIG_DATA['CHICKEN'].default_action['FEEDING'] = {
				x = 0, 
				y = 0, 
				z = 0,
	
				display_icon_distance = 5.0,
				action_distance = 2.5,
				adjust_icon_height = 0.5
			}

			ENTITIES_CONFIG_DATA['CHICKEN'].default_action['DELIVERY'] = { 
				x = 0, 
				y = 0, 
				z = 0, 
				h = 0,
				adjust_icon_height = 1.0,
				action_distance = 1.3
			}
			
			-- spawn animal, eggs, feedbag

			if GetTableLength(ENTITIES_CONFIG_DATA['CHICKEN'].actions['SPAWN']) > 0 then 

				for _, entity in pairs (ENTITIES_CONFIG_DATA['CHICKEN'].actions['SPAWN']) do 

					local model = 'a_c_chicken_01'
					LoadModel(model)

					local _entity = CreatePed(GetHashKey(model), entity.x, entity.y, entity.z, entity.h, false, false, false, false )
	
					SetRandomOutfitVariation(_entity, true) -- set first outfit
					SetModelAsNoLongerNeeded(GetHashKey(model))
					SetEntityInvincible(_entity, true)
					SetEntityCanBeDamaged(_entity, false)
					SetEntityCollision(_entity, false)
					SetPedScale(_entity, 0.9)
					FreezeEntityPosition(_entity, true)
					SetEntityInvincible(_entity, true)
					SetEntityCanBeDamaged(_entity, false)
					SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(_entity), joaat('PLAYER'))
					PlaceEntityOnGroundProperly(_entity, true)

					PLACED_RANCH_ENTITIES['CHICKEN-SPAWN-' .. _] = { entity = _entity, is_object = false, model = model, coords = { x = entity.x, y = entity.y, z = entity.z, h = entity.h} }

				end

			end


			if GetTableLength(ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN']) > 0 then 

				for _, obj in pairs (ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN']) do 

					LoadModel( 's_gatoregg01x' )

					local toVec  = vector3( obj.x,  obj.y,  obj.z)
					local object = CreateObject(GetHashKey('s_gatoregg01x'), toVec, false, false, false, false, false)
		
					SetEntityVisible(object, true)
					SetEntityCollision(object, true)
		
					if obj.pitch and obj.roll and obj.yaw then  -- 1.1.2 added pitch roll yaw support
						SetEntityRotation(object, obj.pitch,  obj.roll,  obj.yaw, 2)
						SetEntityCoords(object,  obj.x,  obj.y,  obj.z)
					end
		
					FreezeEntityPosition(object, true)
		
					SetEntityFadeIn(object, true)
					PlaceObjectOnGroundProperly(object, true)

					PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. _] = { entity = object, is_object = true, model = 's_gatoregg01x', coords = { x = obj.x, y = obj.y, z = obj.z, pitch = obj.pitch, roll = obj.roll, ywa = obj.yaw } }
				end

			end

			if ENTITIES_CONFIG_DATA['CHICKEN'].actions['FEEDBAG'][1] then 

				local obj = (ENTITIES_CONFIG_DATA['CHICKEN'].actions['FEEDBAG'][1])
				
				LoadModel( 'p_mp_feedbaghang01x' )

				local toVec  = vector3( obj.x,  obj.y,  obj.z)
				local object = CreateObject(GetHashKey('p_mp_feedbaghang01x'), toVec, false, false, false, false, false)
	
				SetEntityVisible(object, true)
				SetEntityCollision(object, true)
	
				if obj.pitch and obj.roll and obj.yaw then  -- 1.1.2 added pitch roll yaw support
					SetEntityRotation(object, obj.pitch,  obj.roll,  obj.yaw, 2)
					SetEntityCoords(object,  obj.x,  obj.y,  obj.z)
				end
	
				FreezeEntityPosition(object, true)
	
				SetEntityFadeIn(object, true)
				--PlaceObjectOnGroundProperly(object, true)

				PLACED_RANCH_ENTITIES['CHICKEN-FEEDBAG-1'] = { entity = object, is_object = true, model = 'p_mp_feedbaghang01x', coords = { x = obj.x, y = obj.y, z = obj.z, pitch = obj.pitch, roll = obj.roll, ywa = obj.yaw } }

			end

		end

		if ENTITIES_CONFIG_DATA['PIG'] == nil then 

			ENTITIES_CONFIG_DATA['PIG'] = {}

			ENTITIES_CONFIG_DATA['PIG'].actions = {
				['SPAWN'] = getRanchData.Animals['a_c_pig_01'].SpawnCoords,
			}
			
			ENTITIES_CONFIG_DATA['PIG'].default_action = {}
			ENTITIES_CONFIG_DATA['PIG'].count = getRanchData.Animals['a_c_pig_01'].Total

			ENTITIES_CONFIG_DATA['PIG'].default_action['SPAWN'] = { x = 0, y = 0, z = 0 }

			if GetTableLength(ENTITIES_CONFIG_DATA['PIG'].actions['SPAWN']) > 0 then 

				for _, entity in pairs (ENTITIES_CONFIG_DATA['PIG'].actions['SPAWN']) do 

					local model = 'a_c_pig_01'
					LoadModel(model)

					local _entity = CreatePed(GetHashKey(model), entity.x, entity.y, entity.z, entity.h, false, false, false, false )
	
					SetRandomOutfitVariation(_entity, true) -- set first outfit
					SetModelAsNoLongerNeeded(GetHashKey(model))
					SetEntityInvincible(_entity, true)
					SetEntityCanBeDamaged(_entity, false)
					SetEntityCollision(_entity, false)
					SetPedScale(_entity, 0.9)
					FreezeEntityPosition(_entity, true)
					SetEntityInvincible(_entity, true)
					SetEntityCanBeDamaged(_entity, false)
					SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(_entity), joaat('PLAYER'))

					PLACED_RANCH_ENTITIES['PIG-SPAWN-' .. _] = { entity = _entity, is_object = false, model = model, coords = { x = entity.x, y = entity.y, z = entity.z, h = entity.h} }

				end

			end
		end

	end

	CURRENT_LOADED_DATA_COUNT = 0

	local BUTTONS = {

		'COST',
		'REQUIRED_JOBS',
		'MAIN_COORDS',
		'ANIMAL_STORE',
		'MILK_CONTAINER',
		'WATER_BARREL',
		'HAY_BARREL',
		'PITCH_FORK',
		'CAULDRON',
		'ANIMALS',
		'HERDING',
	}

	for _, button in pairs (BUTTONS) do 
		SendNUIMessage({ 
			action = 'insertButton', 
			action_index = button, 
			locale = Locales['MENU_BUTTON_' .. button] 
		})

	end

    Wait(250)
    ToggleUI(true, 'main')

	Citizen.CreateThread(function()

		while PlayerData.HasNUIActive do
            Wait(0)

			local player = PlayerPedId()
			local isDead = IsEntityDead(player)	

            DisableControlAction(0, Config.HorseWhistleKey, true) -- Jump
			DisableControlAction(0, Config.WagonWhistleKey, true) -- Jump
            
            DisableControlAction(0, 0xE6F612E4, true) -- 1
            DisableControlAction(0, 0x1CE6D9EB, true) -- 2
            DisableControlAction(0, 0x4F49CC4C, true) -- 3
            DisableControlAction(0, 0x8F9F9E58, true) -- 4
            DisableControlAction(0, 0xAB62E997, true) -- 5
            DisableControlAction(0, 0xA1FDE2A6, true) -- 6
            DisableControlAction(0, 0xB03A913B, true) -- 7
            DisableControlAction(0, 0x42385422, true) -- 8

			if isDead then 
                CloseNUI()
            end

		end
	
	end)

	Citizen.CreateThread(function()

		while PlayerData.HasNUIActive do
	
			local sleep = 1500
	
			local player = PlayerPedId()
			local coords = GetEntityCoords(player)
	
			for _, entity in pairs (PLACED_RANCH_ENTITIES) do 
	
				if DoesEntityExist(entity.entity) then
	
					local entityCoords = GetEntityCoords(entity.entity)
					local distance     = #(coords - entityCoords)
	
					if distance <= 10.0 then
						sleep = 0
						DrawText3D(entityCoords.x, entityCoords.y, entityCoords.z + 0.65, "#".. _)
					end
	
				end
	
			end

			Wait(sleep)
	
		end
	
	end)

	Citizen.CreateThread(function()

		while PlayerData.HasNUIActive do

			local sleep = 1500
	
			local player = PlayerPedId()
			local coords = GetEntityCoords(player)
	
			for _, herding_point in pairs (TOTAL_HERDING_POINTS) do 

				if herding_point.x and herding_point.y and herding_point.z then
					local pointCoords = vector3(herding_point.x, herding_point.y, herding_point.z)
					local distance     = #(coords - pointCoords)
	
					if distance <= Config.RenderHerdingPointDistance then
						sleep = 0
						DrawText3D(pointCoords.x, pointCoords.y, pointCoords.z + 0.65, "#HERDING_POINT-".. _)
						
						if Config.HerdingActionMarkers.Enabled then
							local RGBA = Config.HerdingActionMarkers.RGBA
							Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, pointCoords.x, pointCoords.y, pointCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.3, RGBA.r, RGBA.g, RGBA.b, RGBA.a, false, true, 2, false, false, false, false)
						end
	
					end

				end

			end

			for _, spawn_point in pairs (TOTAL_HERDING_SPAWN_POINTS) do 

				local pointCoords = vector3(spawn_point.x, spawn_point.y, spawn_point.z)
				local distance     = #(coords - pointCoords)

				if distance <= Config.RenderHerdingPointDistance then
					sleep = 0
					DrawText3D(pointCoords.x, pointCoords.y, pointCoords.z + 0.65, "#SPAWN_POINT-".. _)

					if Config.HerdingActionMarkers.Enabled then
						local RGBA = Config.HerdingActionMarkers.RGBA
						Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, pointCoords.x, pointCoords.y, pointCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.3, RGBA.r, RGBA.g, RGBA.b, RGBA.a, false, true, 2, false, false, false, false)
					end
				end

			end

			for _, spawn_point in pairs (TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS) do 

				local pointCoords = vector3(spawn_point.x, spawn_point.y, spawn_point.z)
				local distance     = #(coords - pointCoords)

				if distance <= Config.RenderHerdingPointDistance then
					sleep = 0
					DrawText3D(pointCoords.x, pointCoords.y, pointCoords.z + 0.65, "#WOLF_SPAWN_POINT-".. _)

					if Config.HerdingWolfActionMarkers.Enabled then
						local RGBA = Config.HerdingWolfActionMarkers.RGBA
						Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, pointCoords.x, pointCoords.y, pointCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.3, RGBA.r, RGBA.g, RGBA.b, RGBA.a, false, true, 2, false, false, false, false)
					end
				end

			end

			Wait(sleep)

		end

	end)

end

function CloseNUI()
    if PlayerData.HasNUIActive then SendNUIMessage({action = 'close'}) end
end

function SendNUINotification(message, messageType, duration)

    SendNUIMessage({ 
        action = 'sendNotification',
        notification_data = { 
            message = message, 
            type = messageType, 
            color = Config.NotificationColors[messageType], 
            duration = duration 
        }
    })

end

---------------------------------------------------------------
--[[ Events ]]--
---------------------------------------------------------------
RegisterNetEvent("tp_ranch_creator:client:open")
AddEventHandler("tp_ranch_creator:client:open", function(ranchId)
	OpenRanchCreator(ranchId)
end)


RegisterNetEvent("tp_ranch_creator:client:close")
AddEventHandler("tp_ranch_creator:client:close", function()
    CloseNUI()
end)

RegisterNetEvent("tp_ranch_creator:client:has_active_editor")
AddEventHandler("tp_ranch_creator:client:has_active_editor", function(state) -- 1.0.2
    -- todo nothing
end)

---------------------------------------------------------------
--[[ NUI Callbacks ]]--
---------------------------------------------------------------

RegisterNUICallback('close', function()
	ToggleUI(false)
end)

RegisterNUICallback('request_buttons', function()

	SendNUIMessage({action = 'reset_buttons'}) 

	local BUTTONS = {

		'COST',
		'REQUIRED_JOBS',
		'MAIN_COORDS',
		'ANIMAL_STORE',
		'MILK_CONTAINER',
		'WATER_BARREL',
		'HAY_BARREL',
		'PITCH_FORK',
		'CAULDRON',
		'ANIMALS',
		'HERDING'
	}

	for _, button in pairs (BUTTONS) do 
		SendNUIMessage({ 
			action = 'insertButton', 
			action_index = button, 
			locale = Locales['MENU_BUTTON_' .. button] 
		})

	end
end)

RegisterNUICallback('request_animals_section_buttons', function()

	SendNUIMessage({action = 'reset_animal_section_buttons'}) 

	local BUTTONS = {
		'COW',
		'GOAT',
		'SHEEP',
		'CHICKEN',
		'PIG',
	}

	for _, button in pairs (BUTTONS) do 
		SendNUIMessage({ 
			action = 'insertAnimalSectionButton', 
			action_index = button, 
			locale = Locales['MENU_ANIMAL_SECTION_BUTTON_' .. button] 
		})

	end
end)

RegisterNUICallback('request_herding_section_buttons', function()

	SendNUIMessage({action = 'reset_herding_section_buttons'}) 

	local BUTTONS = {
		'SPAWN_POINTS',
		'HERDING_POINTS',
		'WOLF_ATTACKS',
	}

	for _, button in pairs (BUTTONS) do 
		SendNUIMessage({ 
			action = 'insertHerdingSectionButton', 
			action_index = button, 
			locale = Locales['MENU_HERDING_SECTION_BUTTON_' .. button] 
		})

	end
end)

RegisterNUICallback('request_config_data', function(data)

	CURRENT_LOADED_DATA_COUNT = 0 

	while CURRENT_LOADED_DATA_COUNT ~= 8 do 
		Wait(50)
	end

	SendNUIMessage({ action = 'displayAllConfigData' })
end)

-- data.section
RegisterNUICallback('request_selected_animal_config_data', function(data)

	if ENTITIES_CONFIG_DATA[data.section] == nil then 

		ENTITIES_CONFIG_DATA[data.section] = {}
		ENTITIES_CONFIG_DATA[data.section].actions = {}
		ENTITIES_CONFIG_DATA[data.section].default_action = {}
		ENTITIES_CONFIG_DATA[data.section].count = 0
	end

	if ENTITIES_CONFIG_DATA[data.section].default_action['SPAWN'] == nil then 
		ENTITIES_CONFIG_DATA[data.section].default_action['SPAWN'] = { x = 0, y = 0, z = 0, h = 0}
	end


	if ENTITIES_CONFIG_DATA[data.section].default_action['MILKING'] == nil then 
		ENTITIES_CONFIG_DATA[data.section].default_action['MILKING'] = { x = 0, y = 0, z = 0, h = 0}
	end


	if ENTITIES_CONFIG_DATA[data.section].default_action['BUCKET'] == nil then 
		ENTITIES_CONFIG_DATA[data.section].default_action['BUCKET'] = { x = 0, y = 0, z = 0 }
	end

	
	if ENTITIES_CONFIG_DATA[data.section].default_action['POOP'] == nil then 
		ENTITIES_CONFIG_DATA[data.section].default_action['POOP'] = { x = 0, y = 0, z = 0 }
	end

	if ENTITIES_CONFIG_DATA[data.section].default_action['SHEARING'] == nil then 
		ENTITIES_CONFIG_DATA[data.section].default_action['SHEARING'] = { x = 0, y = 0, z = 0, h = 0 }
	end


	if ENTITIES_CONFIG_DATA[data.section].default_action['EGG_SPAWN'] == nil then 
		ENTITIES_CONFIG_DATA[data.section].default_action['EGG_SPAWN'] = { x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0 }
	end

	
	if ENTITIES_CONFIG_DATA[data.section].default_action['FEEDBAG'] == nil then 
		ENTITIES_CONFIG_DATA[data.section].default_action['FEEDBAG'] = {
			x = 0, 
			y = 0, 
			z = 0, 
			pitch = 0, 
			roll = 0,
			yaw = 0, 
			render_distance = 30.0,

			action_distance = 1.5,
			display_icon_distance = 5.0,
			adjust_icon_height = 2.0
		}
	end


	if ENTITIES_CONFIG_DATA[data.section].default_action['FEEDING'] == nil then 
		ENTITIES_CONFIG_DATA[data.section].default_action['FEEDING'] = {
			x = 0, 
			y = 0, 
			z = 0,

			display_icon_distance = 5.0,
			action_distance = 2.5,
			adjust_icon_height = 0.5
		}
	end

		
	if ENTITIES_CONFIG_DATA[data.section].default_action['DELIVERY'] == nil then 
		ENTITIES_CONFIG_DATA[data.section].default_action['DELIVERY'] = { 
			x = 0, 
			y = 0, 
			z = 0, 
			h = 0,
			adjust_icon_height = 1.0,
			action_distance = 1.3
		}
	end

	SendNUIMessage({ 
		action = 'sendLatestSelectedAnimalConfigData', 
		config_data = ENTITIES_CONFIG_DATA[data.section].actions, 
		default_config_data = ENTITIES_CONFIG_DATA[data.section].default_action,
		animal = data.section,
	})

	Wait(250)
	CURRENT_LOADED_DATA_COUNT = CURRENT_LOADED_DATA_COUNT + 1

end)

-- @param data.section
-- @param data.list_class
RegisterNUICallback('request_animal_section_buttons', function(data)

	local listClassName = data.list_class

	local BUTTONS = {}

	if data.section == 'COW' then 

		BUTTONS = {
			{ page = 'SPAWN', label = Locales['NUI_COW_SPAWN_BUTTON'] },
			{ page = 'MILKING', label = Locales['NUI_COW_MILKING_ACTION_BUTTON'] },
			{ page = 'BUCKET', label = Locales['NUI_COW_MILKING_BUCKET_BUTTON'] },
			{ page = 'POOP', label = Locales['NUI_COW_SPAWN_POOP_BUTTON'] },
		}

	end

	if data.section == 'GOAT' then 

		BUTTONS = {
			{ page = 'SPAWN', label = Locales['NUI_GOAT_SPAWN_BUTTON'] },
			{ page = 'MILKING', label = Locales['NUI_GOAT_MILKING_ACTION_BUTTON'] },
			{ page = 'BUCKET', label = Locales['NUI_GOAT_MILKING_BUCKET_BUTTON'] },
			{ page = 'POOP', label = Locales['NUI_GOAT_SPAWN_POOP_BUTTON'] },
		}

	end

	if data.section == 'SHEEP' then 

		BUTTONS = {
			{ page = 'SPAWN', label = Locales['NUI_SHEEP_SPAWN_BUTTON'] },
			{ page = 'SHEARING', label = Locales['NUI_SHEEP_SHEARING_ACTION_BUTTON'] },
			{ page = 'POOP', label = Locales['NUI_SHEEP_SPAWN_POOP_BUTTON'] },
		}

	end

	if data.section == 'CHICKEN' then 

		BUTTONS = {
			{ page = 'SPAWN', label = Locales['NUI_CHICKEN_SPAWN_BUTTON'] },
			{ page = 'EGG_SPAWN', label = Locales['NUI_CHICKEN_EGG_SPAWN_BUTTON'] },
			{ page = 'FEEDBAG', label = Locales['NUI_CHICKEN_FEEDBAG_BUTTON'] },
			{ page = 'FEEDING', label = Locales['NUI_CHICKEN_FEEDING_BUTTON'] },
			{ page = 'DELIVERY', label = Locales['NUI_CHICKEN_CORN_DELIVERY_BUTTON'] },
		}

	end

	
	if data.section == 'PIG' then 

		BUTTONS = {
			{ page = 'SPAWN', label = Locales['NUI_PIG_SPAWN_BUTTON'] },
		}

	end


	for _, button in pairs (BUTTONS) do 
		SendNUIMessage({ 
			action = 'insertAnimalTypeSectionButton', 
			action_index = button.page, 
			locale = button.label,
			list_class = listClassName
		})

	end
end)

RegisterNUICallback('request_herding_points_section', function(data)
	local highestCount = tonumber(data.highestCount)

	if TOTAL_HERDING_POINTS == nil then 
		TOTAL_HERDING_POINTS = {}
	end

	if highestCount == 0 then

		SendNUIMessage({ 
			action = 'displayHerdingPointsSection', 
			description = Locales['NUI_HERDING_POINTS_NOT_ANIMALS_AVAILABLE'],
			color = '#b32828',
			allowed = false,
		})

		--TOTAL_HERDING_POINTS = {}

		return 
	end

	SendNUIMessage({ 
		action = 'displayHerdingPointsSection', 
		description = Locales['NUI_HERDING_POINTS_DESCRIPTION'],
		color = '#8f8f8f',
		allowed = true,
	})

	if GetTableLength(TOTAL_HERDING_POINTS) > 0 then

		for i = 1, GetTableLength(TOTAL_HERDING_POINTS) do

			local formatted = tableToLua(TOTAL_HERDING_POINTS[i])

			if formatted ~= 'n/a' then
				SendNUIMessage({ 
					action             = 'insertHerdingPointListElement', 
					spawn_point_count_index = i,
					input_data         = formatted,
				})
			end
	
		end

	end

end)

RegisterNUICallback('delete_herding_point_index', function(data)
	local index = tonumber(data.spawn_point_index)
	
	if GetTableLength(TOTAL_HERDING_POINTS) > 1 then
  
		while TOTAL_HERDING_POINTS[index + 1] ~= nil do
			TOTAL_HERDING_POINTS[index] = TOTAL_HERDING_POINTS[index + 1]
			index = index + 1
		end
		
	end
	
	TOTAL_HERDING_POINTS[index] = nil

	SendNUIMessage({ action = 'reset_herding_point_list' })

	if GetTableLength(TOTAL_HERDING_POINTS) > 0 then

		for i = 1, GetTableLength(TOTAL_HERDING_POINTS) do
			
			SendNUIMessage({ 
				action             = 'insertHerdingPointListElement', 
				spawn_point_count_index = i,
				input_data         = tableToLua(TOTAL_HERDING_POINTS[i]),
			})
		end

	end
end)

RegisterNUICallback('request_herding_points_config_data', function(data)
	
	if TOTAL_HERDING_POINTS == nil then 
		TOTAL_HERDING_POINTS = {}
	end

	SendNUIMessage({ 
		action = 'sendLatestHerdingPointsConfigData', 
		config_data = TOTAL_HERDING_POINTS, 
	})

	if data.count then
		CURRENT_LOADED_DATA_COUNT = CURRENT_LOADED_DATA_COUNT + 1
	end

end)


RegisterNUICallback('request_herding_spawn_points_config_data', function(data)
	local highestCount = tonumber(data.highestCount)

	if TOTAL_HERDING_SPAWN_POINTS == nil then 
		TOTAL_HERDING_SPAWN_POINTS = {}
	end

	for i = 1, highestCount do
        if TOTAL_HERDING_SPAWN_POINTS[i] == nil then
            TOTAL_HERDING_SPAWN_POINTS[i] = { x = 0, y = 0, z = 0, h = 0}
        end
    end

	SendNUIMessage({ 
		action = 'sendLatestHerdingSpawnPointsConfigData', 
		config_data = TOTAL_HERDING_SPAWN_POINTS, 
	})

	if data.count then
		CURRENT_LOADED_DATA_COUNT = CURRENT_LOADED_DATA_COUNT + 1
	end

	
end)



RegisterNUICallback('request_herding_wolf_attacks_config_data', function(data)
	if TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS == nil then 
		TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS = {}
	end

	SendNUIMessage({ 
		action = 'sendLatestHerdingWolfAttacksConfigData', 
		config_data = TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS, 
	})

	if data.count then
		CURRENT_LOADED_DATA_COUNT = CURRENT_LOADED_DATA_COUNT + 1
	end

end)

RegisterNUICallback('delete_herding_wolf_attack_point_index', function(data)
	local index = tonumber(data.spawn_point_index)
	
	if GetTableLength(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS) > 1 then
  
		while TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS[index + 1] ~= nil do
			TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS[index] = TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS[index + 1]
			index = index + 1
		end
		
	end
	
	TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS[index] = nil

	SendNUIMessage({ action = 'reset_herding_wolf_attacks_list' })

	if GetTableLength(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS) > 0 then

		for i = 1, GetTableLength(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS) do
			
			SendNUIMessage({ 
				action             = 'insertHerdingWolfAttacksListElement', 
				spawn_point_count_index = i,
				input_data         = tableToLua(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS[i]),
			})
		end

	end
end)

RegisterNUICallback('request_herding_wolf_attacks_points_section', function(data)
	local highestCount = tonumber(data.highestCount)

	if TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS == nil then 
		TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS = {}
	end

	if highestCount == 0 then

		SendNUIMessage({ 
			action = 'displayHerdingWolfAttacksPointsSection', 
			description = Locales['NUI_HERDING_WOLF_ATTACKS_STATE_DESCRIPTION'],
			description2 = "",
			color = '#b32828',
			allowed = false,
		})

		--TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS = {}

		return 
	end

	SendNUIMessage({ 
		action = 'displayHerdingWolfAttacksPointsSection', 
		description = Locales['NUI_HERDING_WOLF_ATTACKS_STATE_DESCRIPTION'],
		description2 = Locales['NUI_HERDING_WOLF_ATTACKS_CHANCE_DESCRIPTION'],
		color = '#8f8f8f',
		allowed = true,
	})

	if GetTableLength(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS) > 0 then

		for i = 1, GetTableLength(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS) do
			SendNUIMessage({ 
				action             = 'insertHerdingWolfAttacksListElement', 
				spawn_point_count_index = i,
				input_data         = tableToLua(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS[i]),
			})
	
		end

	end

end)

RegisterNUICallback('request_spawn_points_section', function(data)
	local highestCount = tonumber(data.highestCount)

	if TOTAL_HERDING_SPAWN_POINTS == nil then 
		TOTAL_HERDING_SPAWN_POINTS = {}
	end

	if highestCount == 0 then

		SendNUIMessage({ 
			action = 'displayHerdingSpawnPointsSection', 
			description = Locales['NUI_HERDING_SPAWN_POINTS_NOT_ANIMALS_AVAILABLE'],
			color = '#b32828',
		})

		--TOTAL_HERDING_SPAWN_POINTS = {}

		return 
	end

    for i = 1, highestCount do
        if TOTAL_HERDING_SPAWN_POINTS[i] == nil then
            TOTAL_HERDING_SPAWN_POINTS[i] = { x = 0, y = 0, z = 0, h = 0}
        end
    end

	-- Remove entries above the new highest count
    for i = highestCount + 1, #TOTAL_HERDING_SPAWN_POINTS do
        TOTAL_HERDING_SPAWN_POINTS[i] = nil
    end

	SendNUIMessage({ 
		action = 'displayHerdingSpawnPointsSection', 
		description = Locales['NUI_HERDING_SPAWN_POINTS_DESCRIPTION'],
		color = '#8f8f8f',
	})

	for i = 1, highestCount do
		SendNUIMessage({ 
			action             = 'insertHerdingSpawnPointListElement', 
			spawn_point_count_index = i,
			button_locale      = Locales['NUI_HERDING_SPAWN_POINT_SET_SPAWNPOINT_BUTTON'],
			input_data         = tableToLua(TOTAL_HERDING_SPAWN_POINTS[i]),
			is_default         = tablesEqual({ x = 0, y = 0, z = 0, h = 0}, TOTAL_HERDING_SPAWN_POINTS[i])
		})

	end

end)

-- @param data.section
-- @param data.action_index
-- @param data.count 
RegisterNUICallback('request_selected_animal_type_actions_section', function(data)

	local totalCount = data.count

	if data.count then 
		totalCount = tonumber(data.count)
	else
		totalCount = ENTITIES_CONFIG_DATA[data.section].count
	end

	if totalCount == 0 and data.action_index ~= 'DELIVERY' and data.action_index ~= 'FEEDING' and data.action_index ~= 'FEEDBAG' and data.action_index ~= 'EGG_SPAWN' then 
		SendNUIMessage({ 
			action = 'displayAnimalActionsSection', 
			description = Locales['NUI_' .. data.section .. '_NOT_COUNT_AVAILABLE'],
			color = '#b32828',
		})
		return 
	end

	if ENTITIES_CONFIG_DATA[data.section] == nil then 

		ENTITIES_CONFIG_DATA[data.section] = {}
		ENTITIES_CONFIG_DATA[data.section].actions = {}
		ENTITIES_CONFIG_DATA[data.section].default_action = {}
		ENTITIES_CONFIG_DATA[data.section].count = totalCount
	end

	-- If total animal count has been modified, we update the count
	if ENTITIES_CONFIG_DATA[data.section].count ~= totalCount then 
		ENTITIES_CONFIG_DATA[data.section].count = totalCount
	end

	if ENTITIES_CONFIG_DATA[data.section].actions[data.action_index] == nil then 
		ENTITIES_CONFIG_DATA[data.section].actions[data.action_index] = {}
	end


	local description
	local buttonLocale

	if data.action_index == 'SPAWN' then 
		description  = Locales['NUI_' .. data.section .. '_SPAWN_DESC']
		buttonLocale = Locales['NUI_ANIMALS_ACTIONS_SET_SPAWN_POINT']

		if ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] == nil then 
			ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] = { x = 0, y = 0, z = 0, h = 0}
		end

		for i = 1, totalCount do

			if not ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i] then
				ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i] = { x = 0, y = 0, z = 0, h = 0 }
			end
			
		end

	end

	if data.action_index == 'MILKING' then 
		description  = Locales['NUI_' .. data.section .. '_MILKING_ACTION_DESC']
		buttonLocale = Locales['NUI_ANIMALS_ACTIONS_SET_POSITION']

		if ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] == nil then 
			ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] = { x = 0, y = 0, z = 0, h = 0}
		end

		for i = 1, totalCount do
			if not ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i] then
				ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i] = { x = 0, y = 0, z = 0, h = 0}
			end
		end
	end

	if data.action_index == 'BUCKET' then 
		description  = Locales['NUI_' .. data.section .. '_MILKING_BUCKET_DESC']
		buttonLocale = Locales['NUI_ANIMALS_ACTIONS_SET_POSITION']

		if ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] == nil then 
			ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] = { x = 0, y = 0, z = 0 }
		end

		for i = 1, totalCount do

			if not ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i] then
				ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i] = { x = 0, y = 0, z = 0 }
			end
			
		end

	end

	if data.action_index == 'POOP' then 
		description = Locales['NUI_' .. data.section .. '_SPAWN_POOP_DESC']
		buttonLocale = Locales['NUI_ANIMALS_ACTIONS_SET_POSITION']

		if ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] == nil then 
			ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] = { x = 0, y = 0, z = 0 }
		end

		for i = 1, totalCount do

			if not ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i] then
				ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i] = { x = 0, y = 0, z = 0 }
			end
			
		end

	end

	if data.action_index == 'SHEARING' then 
		description = Locales['NUI_' .. data.section .. '_SHEARING_ACTION_DESC']
		buttonLocale = Locales['NUI_ANIMALS_ACTIONS_SET_POSITION']

		if ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] == nil then 
			ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] = { x = 0, y = 0, z = 0, h = 0 }
		end

		for i = 1, totalCount do

			if not ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i] then
				ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i] = { x = 0, y = 0, z = 0, h = 0,  }
			end
			
		end
		
	end

	if data.action_index == 'EGG_SPAWN' then 
		description = Locales['NUI_' .. data.section .. '_EGG_SPAWN_DESC']
		buttonLocale = Locales['NUI_ANIMALS_ACTIONS_EDIT_POSITION']

		if ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] == nil then 
			ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] = { x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0 }
		end

		SendNUIMessage({ action = 'displayActionsCreateButton'})

	end

	if data.action_index == 'FEEDBAG' then 
		description = Locales['NUI_' .. data.section .. '_FEEDBAG_DESC']
		buttonLocale = Locales['NUI_ANIMALS_ACTIONS_SET_POSITION']

		if ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] == nil then 
			ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] = {
				x = 0, 
				y = 0, 
				z = 0, 
				pitch = 0, 
				roll = 0,
				yaw = 0, 
				render_distance = 30.0,

				action_distance = 1.5,
				display_icon_distance = 5.0,
				adjust_icon_height = 2.0
			}
		end

		if not ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][1] then

			ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][1] = {
				x = 0, 
				y = 0, 
				z = 0, 
				pitch = 0, 
				roll = 0,
				yaw = 0, 
				render_distance = 30.0,

				action_distance = 1.5,
				display_icon_distance = 5.0,
				adjust_icon_height = 2.0
			}

		end


	end

	if data.action_index == 'FEEDING' then 
		description = Locales['NUI_' .. data.section .. '_FEEDING_DESC']
		buttonLocale = Locales['NUI_ANIMALS_ACTIONS_SET_POSITION']
		
		if ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] == nil then 
			ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] = {
				x = 0, 
				y = 0, 
				z = 0,

				display_icon_distance = 5.0,
				action_distance = 2.5,
				adjust_icon_height = 0.5
			}
		end

		if not ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][1] then
				
			ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][1] = {
				x = 0, 
				y = 0, 
				z = 0,

				display_icon_distance = 5.0,
				action_distance = 2.5,
				adjust_icon_height = 0.5
			}
		end

	end

	if data.action_index == 'DELIVERY' then 
		description = Locales['NUI_' .. data.section .. '_CORN_DELIVERY_DESC']
		buttonLocale = Locales['NUI_ANIMALS_ACTIONS_SET_POSITION']

		if ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] == nil then 
			ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index] = { 
				x = 0, 
				y = 0, 
				z = 0, 
				h = 0,
				adjust_icon_height = 1.0,
				action_distance = 1.3
			}
		end

		if not ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][1] then
				
			ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][1] = { 
				x = 0, 
				y = 0, 
				z = 0, 
				h = 0,
				adjust_icon_height = 1.0,
				action_distance = 1.3
			}

		end

	end

	SendNUIMessage({ 
		action = 'displayAnimalActionsSection', 
		description = description,
		color = '#8f8f8f',
	})

	if data.action_index ~= 'DELIVERY' and data.action_index ~= 'FEEDING' and data.action_index ~= 'FEEDBAG' and data.action_index ~= 'EGG_SPAWN' then
		for i = 1, totalCount do
			SendNUIMessage({ 
				action             = 'insertSelectedAnimalTypeActionListElement', 
				animal_count_index = i,
				input_data         = tableToLua(ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i]),
				button_locale      = buttonLocale,
				is_default         = tablesEqual(ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index], ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i])
			})
	
		end
	elseif data.action_index == 'DELIVERY' or data.action_index == 'FEEDING' or data.action_index == 'FEEDBAG' then
		
		SendNUIMessage({ 
			action             = 'insertSelectedAnimalTypeActionListElement', 
			animal_count_index = 1,
			input_data         = tableToLua(ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][1]),
			button_locale      = buttonLocale,
			is_default         = tablesEqual(ENTITIES_CONFIG_DATA[data.section].default_action[data.action_index], ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][1])
		})

	elseif data.action_index == 'EGG_SPAWN' then
		
		if GetTableLength(ENTITIES_CONFIG_DATA[data.section].actions[data.action_index]) > 0 then

			for i = 1, GetTableLength(ENTITIES_CONFIG_DATA[data.section].actions[data.action_index]) do
				SendNUIMessage({ 
					action             = 'insertSelectedAnimalTypeEggActionListElement', 
					animal_count_index = i,
					input_data         = tableToLua(ENTITIES_CONFIG_DATA[data.section].actions[data.action_index][i]),
					button_locale      = buttonLocale,
					button_locale2     = Locales['NUI_ANIMALS_ACTIONS_CREATE_POSITION'],
				})
			end

		end

	end

end)

RegisterNUICallback('delete_spawned_egg_index', function(data)
	local index = tonumber(data.egg_index)
	
	if GetTableLength(ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN']) > 1 then
  
		while ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN'][index + 1] ~= nil do
			ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN'][index] = ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN'][index + 1]
			index = index + 1
		end
		
	end
	
	ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN'][index] = nil

	if PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. index] then 
		RemoveEntityProperly(PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. index].entity, joaat(PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. index].model))

		PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. index] = nil
	end

	SendNUIMessage({ action = 'resetActionsList' })

	if GetTableLength(ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN']) > 0 then

		for i = 1, GetTableLength(ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN']) do
			SendNUIMessage({ 
				action             = 'insertSelectedAnimalTypeEggActionListElement', 
				animal_count_index = i,
				input_data         = tableToLua(ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN'][i]),
				button_locale      = Locales['NUI_ANIMALS_ACTIONS_EDIT_POSITION'],
				button_locale2     = Locales['NUI_ANIMALS_ACTIONS_CREATE_POSITION'],
			})
		end

	end
end)

RegisterNUICallback('requestNotification', function(data)
    SendNUINotification(Locales[data.message].text, data.messageType, Locales[data.message].duration)
end)

---------------------------------------------------------------
--[[ Threads ]]--
---------------------------------------------------------------

Citizen.CreateThread(function()
	TriggerServerEvent("tp_ranch_creator:server:addChatSuggestions")
end)
