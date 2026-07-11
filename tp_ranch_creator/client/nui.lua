
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

	else
		PlayerData.HasNUIHidden = false
		PlayerData.IsBusy = false
	end

    SendNUIMessage({ type = "enable", enable = display, window = window })
end

function tableToLua(tbl)
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
        "adjust_icon_height",
        "action_distance",
    }

    local parts = {}
    local used = {}

    -- Write keys in the preferred order
    for _, key in ipairs(order) do
        if tbl[key] ~= nil then
            local value = tbl[key]

            if type(value) == "string" then
                value = string.format("%q", value)
            else
                value = tostring(value)
            end

            table.insert(parts, ("%s = %s"):format(key, value))
            used[key] = true
        end
    end

    -- Write any remaining keys
    for key, value in pairs(tbl) do
        if not used[key] then
            if type(value) == "string" then
                value = string.format("%q", value)
            else
                value = tostring(value)
            end

            table.insert(parts, ("%s = %s"):format(key, value))
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

				local pointCoords = vector3(herding_point.x, herding_point.y, herding_point.z)
				local distance     = #(coords - pointCoords)

				if distance <= Config.RenderHerdingPointDistance then
					sleep = 0
					DrawText3D(pointCoords.x, pointCoords.y, pointCoords.z + 0.65, "#HERDING_POINT-".. _)
					
					if Config.HerdingActionMarkers.Enabled then
						local RGBA = Config.HerdingActionMarkers.RGBA
						Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, pointCoords.x, pointCoords.y, pointCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.3, RGBA.r, RGBA.g, RGBA.b, RGBA.a, false, true, 2, false, false, false, false)
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
						Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, pointCoords.x, pointCoords.y, pointCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.3, RGBA.r, RGBA.g, RGBA.b, RGBA.a, false, true, 2, false, false, false, false)
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
						Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, pointCoords.x, pointCoords.y, pointCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.3, RGBA.r, RGBA.g, RGBA.b, RGBA.a, false, true, 2, false, false, false, false)
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

		TOTAL_HERDING_POINTS = {}

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
			SendNUIMessage({ 
				action             = 'insertHerdingPointListElement', 
				spawn_point_count_index = i,
				input_data         = tableToLua(TOTAL_HERDING_POINTS[i]),
			})
	
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

		TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS = {}

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

		TOTAL_HERDING_SPAWN_POINTS = {}

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
