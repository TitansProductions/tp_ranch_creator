
local IS_PLACEMENT_BUSY = false
PLACED_RANCH_ENTITIES = {}

local Builder = { 
    DefaultCurrentPitch = nil,
    DefaultCurrentRoll  = nil,
    DefaultCurrentYaw   = nil,
    
    CurrentZ            = nil, 
    CurrentPitch        = nil, 
    CurrentRoll         = nil, 
    CurrentYaw          = nil,

	Entity              = nil,
	ModelEntity         = nil,
}


---------------------------------------------------------------
--[[ Functions ]]--
---------------------------------------------------------------

local function split(str)
    local result = {}

    for part in string.gmatch(str, "[^-]+") do
        table.insert(result, part)
    end

    return result
end

ClearPlacedRanchObjectsList = function()

	if GetTableLength(PLACED_RANCH_ENTITIES) > 0 then 

		for action_type, object in pairs (PLACED_RANCH_ENTITIES) do
			RemoveEntityProperly(object.entity, joaat(object.model))
		end
	end

	PLACED_RANCH_ENTITIES = nil
	PLACED_RANCH_ENTITIES = {}
end

---------------------------------------------------------------
--[[ Events ]]--
---------------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

	if Builder.Entity then
		RemoveEntityProperly(Builder.Entity, joaat(Builder.ModelEntity))
	end

	ClearPlacedRanchObjectsList()

end)

---------------------------------------------------------------
--[[ NUI Callbacks ]]--
---------------------------------------------------------------

-- @param data.egg_index
RegisterNUICallback('startEggPlacement', function(data)
	local playerPed = PlayerPedId()

	SetNuiFocus(false, false)
	IS_PLACEMENT_BUSY = true 

	local egg_index = data.egg_index

	Builder.ModelEntity = 's_gatoregg01x'

	LoadModel(Builder.ModelEntity)

	local obj

	if egg_index == nil then 
		local count = 0

		for key, _ in pairs(PLACED_RANCH_ENTITIES) do
			if key:match("^CHICKEN%-EGG_SPAWN%-") then
				count = count + 1
			end
		end
		
		egg_index = count + 1
	end

	if PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. egg_index] then
		obj = PLACED_RANCH_ENTITIES[action_index].entity
		SetEntityCollision(obj, false) -- 1.0.1
	else
		local playerCoords = GetEntityCoords(playerPed)

		obj = CreateObject(GetHashKey(Builder.ModelEntity), playerCoords.x, playerCoords.y, playerCoords.z, false, false, false, false, false)
		SetEntityVisible(obj, true)
		SetEntityCollision(obj, false)
	end

	
	local pitch, roll, yaw = table.unpack(GetEntityRotation(obj, 2))

	Builder.CurrentPitch        = pitch
	Builder.CurrentRoll         = roll
	Builder.CurrentYaw          = yaw

	Builder.DefaultCurrentPitch = pitch
	Builder.DefaultCurrentRoll  = roll
	Builder.DefaultCurrentYaw   = yaw

	Builder.Entity = obj

	Citizen.CreateThread(function()

		while IS_PLACEMENT_BUSY do
	
			Wait(0)

			if Builder.Entity then 

				local hit, coords, entity = RayCastGamePlayCamera(20)

				if Builder.CurrentZ == nil then
					Builder.CurrentZ = coords.z
				end

				SetEntityCoords(Builder.Entity, coords.x, coords.y, Builder.CurrentZ)
				SetEntityRotation(Builder.Entity, Builder.CurrentPitch, Builder.CurrentRoll, Builder.CurrentYaw, 2)

				if IsControlPressed(2, 0xA65EBAB4) then -- Arrow Left
					Builder.CurrentYaw = Builder.CurrentYaw - 1.0
				end
		
				if IsControlPressed(2, 0xDEB34313) then -- Arrow Right
				   Builder.CurrentYaw = Builder.CurrentYaw + 1.0
				end
		
				if IsControlPressed(2, 0x05CA7C52) then -- Arrow Down
					Builder.CurrentZ = Builder.CurrentZ - 0.01
				end
		
				if IsControlPressed(2, 0x6319DB71) then -- Arrow Up
					Builder.CurrentZ = Builder.CurrentZ + 0.01
				end
		
				if IsControlPressed(2, 0x446258B6) then -- PAGE UP
					Builder.CurrentPitch = Builder.CurrentPitch + 1.0
				end
		
				if IsControlPressed(2, 0x3C3DD371) then -- PAGE DOWN
					Builder.CurrentPitch = Builder.CurrentPitch - 1.0
				end
		
				if IsControlPressed(2, 0x3D23549A) then -- [
					Builder.CurrentRoll = Builder.CurrentRoll + 1.0
				end
		
				if IsControlPressed(2, 0xA5BDCD3C) then -- ]
					Builder.CurrentRoll = Builder.CurrentRoll - 1.0
				end
		
				if IsControlPressed(2, 0xE30CD707) then -- Reset 
					Builder.CurrentZ      = nil
					Builder.CurrentPitch  = Builder.DefaultCurrentPitch
					Builder.CurrentRoll   = Builder.DefaultCurrentRoll
					Builder.CurrentYaw    = Builder.DefaultCurrentYaw
		
				end

			else
				DisplayHelp(Locales['PRESS_DISPLAY_ON_BUILDER_SUCCESS'], 0.50, 0.80, 0.35, 0.35, true, 255, 255, 255, 255, true)
				DisplayHelp(Locales['PRESS_DISPLAY_ON_BUILDER_CANCEL'], 0.50, 0.83, 0.35, 0.35, true, 255, 255, 255, 255, true)
			end

			if IsControlJustReleased(0, 0xC7B5340A) then

				local objectCoords        = GetEntityCoords(Builder.Entity)
				local _pitch, _roll, _yaw = table.unpack(GetEntityRotation(Builder.Entity, 2))
				local returned_input_text = string.format('{ x = %s, y = %s, z = %s, pitch = %s, roll = %s, yaw = %s, render_distance = 20.0 }', objectCoords.x, objectCoords.y, objectCoords.z, _pitch, _roll, _yaw)

				SetNuiFocus(true, true)
				IS_PLACEMENT_BUSY = false

				RemoveEntityProperly(Builder.Entity, joaat(Builder.ModelEntity))

				if PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. egg_index] then 
					RemoveEntityProperly(PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. egg_index].entity, joaat(PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. egg_index].model))
				end

				LoadModel(Builder.ModelEntity)

				local obj = CreateObject(GetHashKey(Builder.ModelEntity), objectCoords.x, objectCoords.y, objectCoords.z, false, false, false, false, false)
				
				SetEntityVisible(obj, true)
				SetEntityCollision(obj, true)
				SetEntityRotation(obj, _pitch, _roll, _yaw, 2)
				SetEntityCoords(obj, objectCoords.x, objectCoords.y, objectCoords.z)

				PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. egg_index] = { entity = obj, is_object = true, model = Builder.ModelEntity, coords = objectCoords, pitch = _pitch, roll = _roll, yaw = _yaw}

				ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN'][egg_index] =  { x = objectCoords.x, y = objectCoords.y, z = objectCoords.z, pitch = _pitch, roll = _roll, yaw = _yaw }

				Builder.Entity = nil
				SendNUIMessage({ action = 'hide_builder_info' })

				if GetTableLength(ENTITIES_CONFIG_DATA['CHICKEN'].actions['EGG_SPAWN']) > 0 then

					SendNUIMessage({ action = 'resetActionsList' })

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

			end

			if IsControlPressed(2, 0x4AF4D473) then -- Cancel
    
				SetNuiFocus(true, true)
				IS_PLACEMENT_BUSY = false

				if Builder.Entity then

					if PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. egg_index] then 
						
						local obj_data = PLACED_RANCH_ENTITIES['CHICKEN-EGG_SPAWN-' .. egg_index]
						
						SetEntityCoords(obj_data.entity, obj_data.coords.x, obj_data.coords.y, obj_data.coords.z)
						SetEntityRotation(obj_data.entity, obj_data.pitch, obj_data.roll, obj_data.yaw, 2)
						SetEntityCollision(obj_data.entity, true)
				
					else
						RemoveEntityProperly(Builder.Entity, joaat(Builder.ModelEntity))
					end

					Builder.Entity = nil

					SendNUIMessage({ action = 'hide_builder_info' })
				end
				
                Builder.CurrentZ = nil
    
                Wait(200)
            end

		end

	end)
	
end)

-- @param data.action_index, data.input_class_index, data.model
RegisterNUICallback('startCoordsPlacement', function(data)
	local playerPed = PlayerPedId()

	SetNuiFocus(false, false)
	IS_PLACEMENT_BUSY = true 

	local action_index      = data.action_index
	local input_class_index = data.input_class_index
	local is_animal_section = data.is_animal_section
	local animalActionCount = 0

	if data.object ~= nil then 
		Builder.ModelEntity = data.object

		LoadModel(Builder.ModelEntity)

		local playerCoords = GetEntityCoords(playerPed)

		local obj

		if PLACED_RANCH_ENTITIES[action_index] then
			obj = PLACED_RANCH_ENTITIES[action_index].entity
	    	SetEntityCollision(obj, false) -- 1.0.1
		else
			obj = CreateObject(GetHashKey(Builder.ModelEntity), playerCoords.x, playerCoords.y, playerCoords.z, false, false, false, false, false)
			SetEntityVisible(obj, true)
			SetEntityCollision(obj, false)
		end

		local pitch, roll, yaw = table.unpack(GetEntityRotation(obj, 2))

		Builder.CurrentPitch        = pitch
		Builder.CurrentRoll         = roll
		Builder.CurrentYaw          = yaw
	
		Builder.DefaultCurrentPitch = pitch
		Builder.DefaultCurrentRoll  = roll
		Builder.DefaultCurrentYaw   = yaw

		Builder.Entity = obj

	elseif data.animal ~= nil then 

		Builder.ModelEntity = data.animal
		LoadModel(Builder.ModelEntity)

		local playerCoords = GetEntityCoords(playerPed)
		local entity

		
		local pitch, roll, yaw

		if PLACED_RANCH_ENTITIES[action_index] then
			entity = PLACED_RANCH_ENTITIES[action_index].entity

			pitch, roll, yaw = 0.0, 0.0, (PLACED_RANCH_ENTITIES[action_index].coords.h + 180.0) % 360.0
	    	SetEntityCollision(entity, false) -- 1.0.1
		else
			entity = CreatePed(GetHashKey(Builder.ModelEntity), playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(PlayerPedId()), false, false, false, false )
			
			SetRandomOutfitVariation(entity, true) -- set first outfit
			SetModelAsNoLongerNeeded(GetHashKey(Builder.ModelEntity))
			SetEntityInvincible(entity, true)
			SetEntityCanBeDamaged(entity, false)
			SetEntityCollision(entity, false)
			SetPedScale(entity, 0.9)
			PlaceEntityOnGroundProperly(entity, true)

			pitch, roll, yaw = table.unpack(GetEntityRotation(entity, 2))
		end


		Builder.CurrentPitch        = pitch
		Builder.CurrentRoll         = roll
		Builder.CurrentYaw          = yaw
	
		Builder.DefaultCurrentPitch = pitch
		Builder.DefaultCurrentRoll  = roll
		Builder.DefaultCurrentYaw   = yaw

		Builder.Entity = entity


	end

	Citizen.CreateThread(function()

		while IS_PLACEMENT_BUSY do
	
			Wait(0)

			if Builder.Entity then 

				local hit, coords, entity = RayCastGamePlayCamera(20)

				if Builder.CurrentZ == nil then
					Builder.CurrentZ = coords.z
				end

				SetEntityCoords(Builder.Entity, coords.x, coords.y, Builder.CurrentZ)

				--if data.object then
					SetEntityRotation(Builder.Entity, Builder.CurrentPitch, Builder.CurrentRoll, Builder.CurrentYaw, 2)
				
				--elseif data.animal then 

				--end

				if IsControlPressed(2, 0xA65EBAB4) then -- Arrow Left
					Builder.CurrentYaw = Builder.CurrentYaw - 1.0
				end
		
				if IsControlPressed(2, 0xDEB34313) then -- Arrow Right
				   Builder.CurrentYaw = Builder.CurrentYaw + 1.0
				end
		
				if IsControlPressed(2, 0x05CA7C52) then -- Arrow Down
					Builder.CurrentZ = Builder.CurrentZ - 0.01
				end
		
				if IsControlPressed(2, 0x6319DB71) then -- Arrow Up
					Builder.CurrentZ = Builder.CurrentZ + 0.01
				end
		
				if IsControlPressed(2, 0x446258B6) then -- PAGE UP
					Builder.CurrentPitch = Builder.CurrentPitch + 1.0
				end
		
				if IsControlPressed(2, 0x3C3DD371) then -- PAGE DOWN
					Builder.CurrentPitch = Builder.CurrentPitch - 1.0
				end
		
				if IsControlPressed(2, 0x3D23549A) then -- [
					Builder.CurrentRoll = Builder.CurrentRoll + 1.0
				end
		
				if IsControlPressed(2, 0xA5BDCD3C) then -- ]
					Builder.CurrentRoll = Builder.CurrentRoll - 1.0
				end
		
				if IsControlPressed(2, 0xE30CD707) then -- Reset 
					Builder.CurrentZ      = nil
					Builder.CurrentPitch  = Builder.DefaultCurrentPitch
					Builder.CurrentRoll   = Builder.DefaultCurrentRoll
					Builder.CurrentYaw    = Builder.DefaultCurrentYaw
		
				end

			else
				DisplayHelp(Locales['PRESS_DISPLAY_ON_BUILDER_SUCCESS'], 0.50, 0.80, 0.35, 0.35, true, 255, 255, 255, 255, true)
				DisplayHelp(Locales['PRESS_DISPLAY_ON_BUILDER_CANCEL'], 0.50, 0.83, 0.35, 0.35, true, 255, 255, 255, 255, true)
			end

			if IsControlJustReleased(0, 0xC7B5340A) then

				local coords
				local returned_input_text

				if not containsObjectPlacement then
					coords = GetEntityCoords(PlayerPedId())
				end

				if action_index == 'MAIN_COORDS' then 
					returned_input_text = string.format('vector3(%s, %s, %s)', coords.x, coords.y, coords.z - 1.0)
				end

				if action_index == 'HAY_BARREL' then 
					returned_input_text = string.format('{ x = %s, y = %s, z = %s }', coords.x, coords.y, coords.z - 1.0)
				end

				local objectCoords, _pitch, _roll, _yaw

				if Builder.Entity then 
					objectCoords        = GetEntityCoords(Builder.Entity)
					_pitch, _roll, _yaw = table.unpack(GetEntityRotation(Builder.Entity, 2))
					returned_input_text = string.format('{ x = %s, y = %s, z = %s, pitch = %s, roll = %s, yaw = %s, render_distance = 20.0 }', objectCoords.x, objectCoords.y, objectCoords.z, _pitch, _roll, _yaw)

				end

				if action_index == 'MILK_CONTAINER_2' then -- deliver milk jug
					returned_input_text = string.format('{ x = %s, y = %s, z = %s, action_distance = 0.9 }', coords.x, coords.y, coords.z - 1.0)
				end

				if action_index == 'PITCH_FORK' then
					returned_input_text = string.format('{ x = %s, y = %s, z = %s, pitch = %s, roll = %s, yaw = %s }', objectCoords.x, objectCoords.y, objectCoords.z, _pitch, _roll, _yaw)
				end

				if action_index == 'CAULDRON_1' then
					returned_input_text = string.format('{ object = "p_cauldron01x" x = %s, y = %s, z = %s, pitch = %s, roll = %s, yaw = %s }', objectCoords.x, objectCoords.y, objectCoords.z, _pitch, _roll, _yaw)
				end

				if action_index == 'CAULDRON_2' then
					returned_input_text = string.format('{ x = %s, y = %s, z = %s, h = %s }', coords.x, coords.y, coords.z - 1.0, GetEntityHeading(PlayerPedId()))
				end

				if is_animal_section then 
					local args = split(action_index)
					local animalName, animalActionType = args[1], args[2]

					animalActionCount = tonumber(args[3])
					
					if Builder.Entity then
						objectCoords        = GetEntityCoords(Builder.Entity)
						_pitch, _roll, _yaw = table.unpack(GetEntityRotation(Builder.Entity, 2))

						ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount].x     = objectCoords.x
						ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount].y     = objectCoords.y
						ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount].z     = objectCoords.z

						if data.object then
							ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount].pitch = _pitch
							ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount].roll  = _roll
							ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount].yaw   = _yaw

						elseif data.animal then 
							ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount].h     = _yaw
						end

					else
						ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount].x     = coords.x
						ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount].y     = coords.y
						ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount].z     = coords.z
					end

					returned_input_text = tableToLua(ENTITIES_CONFIG_DATA[animalName].actions[animalActionType][animalActionCount])


				end

				SendNUIMessage({
					action = 'updateInputByName', 
					input_name = input_class_index,
					returned_input_text = returned_input_text,
					is_animal_section = is_animal_section,
					animal_count = animalActionCount,
				})

				SetNuiFocus(true, true)
				IS_PLACEMENT_BUSY = false

				if Builder.Entity then

					RemoveEntityProperly(Builder.Entity, joaat(Builder.ModelEntity))

					if PLACED_RANCH_ENTITIES[action_index] then 
						RemoveEntityProperly(PLACED_RANCH_ENTITIES[action_index].entity, joaat(PLACED_RANCH_ENTITIES[action_index].model))
					end

					if data.object then

						LoadModel(Builder.ModelEntity)

						local obj = CreateObject(GetHashKey(Builder.ModelEntity), objectCoords.x, objectCoords.y, objectCoords.z, false, false, false, false, false)
						
						
						SetEntityVisible(obj, true)
						SetEntityCollision(obj, true)
						SetEntityRotation(obj, _pitch, _roll, _yaw, 2)
						SetEntityCoords(obj, objectCoords.x, objectCoords.y, objectCoords.z)
	
						PLACED_RANCH_ENTITIES[action_index] = { entity = obj, is_object = true, model = Builder.ModelEntity, coords = objectCoords, pitch = _pitch, roll = _roll, yaw = _yaw}

					else

						LoadModel(Builder.ModelEntity)

						local oppositeHeading = (Builder.CurrentYaw + 180.0) % 360.0

						local _entity = CreatePed(GetHashKey(Builder.ModelEntity), objectCoords.x, objectCoords.y, objectCoords.z - 1.0, oppositeHeading, false, false, false, false )
		
						SetRandomOutfitVariation(_entity, true) -- set first outfit
						SetModelAsNoLongerNeeded(GetHashKey(Builder.ModelEntity))
						SetEntityInvincible(_entity, true)
						SetEntityCanBeDamaged(_entity, false)
						SetEntityCollision(_entity, true)
						SetPedScale(_entity, 0.9)
						--PlaceEntityOnGroundProperly(_entity, true)
						FreezeEntityPosition(_entity, true)
						SetEntityInvincible(_entity, true)
						SetEntityCanBeDamaged(_entity, false)
						SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(_entity), joaat('PLAYER'))

						local newCoords = { x = objectCoords.x, y = objectCoords.y, z = objectCoords.z - 1.0, h = oppositeHeading}

						PLACED_RANCH_ENTITIES[action_index] = { entity = _entity, is_object = false, model = Builder.ModelEntity, coords = newCoords }
					end

					Builder.Entity = nil
				end

			end

			if IsControlPressed(2, 0x4AF4D473) then -- Cancel
    
				SetNuiFocus(true, true)
				IS_PLACEMENT_BUSY = false

				if Builder.Entity then

					if PLACED_RANCH_ENTITIES[action_index] then 
						
						local obj_data = PLACED_RANCH_ENTITIES[action_index]

						if obj_data.is_object then
							SetEntityCoords(obj_data.entity, obj_data.coords.x, obj_data.coords.y, obj_data.coords.z)
							SetEntityRotation(obj_data.entity, obj_data.pitch, obj_data.roll, obj_data.yaw, 2)
							SetEntityCollision(obj_data.entity, true)
						else
							SetEntityCoords(obj_data.entity, obj_data.coords.x, obj_data.coords.y, obj_data.coords.z)
							SetEntityCollision(obj_data.entity, true)
							--PlaceEntityOnGroundProperly(obj_data.entity, true)
							FreezeEntityPosition(obj_data.entity, true)
							SetEntityHeading(obj_data.entity, obj_data.coords.h)
							SetEntityInvincible(obj_data.entity, true)
							SetEntityCanBeDamaged(obj_data.entity, false)
							SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(obj_data.entity), joaat('PLAYER'))
											
						end

					else
						RemoveEntityProperly(Builder.Entity, joaat(Builder.ModelEntity))
					end

					Builder.Entity = nil

					SendNUIMessage({ action = 'hide_builder_info' })
				end
				
                Builder.CurrentZ = nil
    
                Wait(200)
            end

		end

	end)

end)

