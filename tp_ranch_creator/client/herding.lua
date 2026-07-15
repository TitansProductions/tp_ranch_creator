
local IS_PLACEMENT_BUSY = false

---------------------------------------------------------------
--[[ NUI Callbacks ]]--
---------------------------------------------------------------

-- @param data.action_index, data.spawnpoint (if exists)
RegisterNUICallback('startHerdingPointPlacement', function(data)
	local playerPed = PlayerPedId()

	SetNuiFocus(false, false)
	IS_PLACEMENT_BUSY = true 

	local action_index = data.action_index
	local spawnpoint   = tonumber(data.spawnpoint)
	local input_class_index = data.input_class_index

	Citizen.CreateThread(function()

		while IS_PLACEMENT_BUSY do
	
			Wait(0)

			DisplayHelp(Locales['PRESS_DISPLAY_ON_BUILDER_SUCCESS'], 0.50, 0.80, 0.35, 0.35, true, 255, 255, 255, 255, true)
			DisplayHelp(Locales['PRESS_DISPLAY_ON_BUILDER_CANCEL'], 0.50, 0.83, 0.35, 0.35, true, 255, 255, 255, 255, true)

			if IsControlJustReleased(0, 0xC7B5340A) then

				local coords  = GetEntityCoords(PlayerPedId())
				local heading = GetEntityHeading(PlayerPedId())

				if action_index == 'SPAWN_POINT' then 
					TOTAL_HERDING_SPAWN_POINTS[spawnpoint] = { x = coords.x, y = coords.y, z = coords.z, h = heading }
					returned_input_text = string.format('{ x = %s, y = %s, z = %s, h = %s }', coords.x, coords.y, coords.z, heading)

					SendNUIMessage({
						action = 'updateHerdingInputByName', 
						input_name = input_class_index,
						returned_input_text = returned_input_text,
					})

				end

				if action_index == 'HERDING_POINT' then 

					if TOTAL_HERDING_POINTS == nil then 
						TOTAL_HERDING_POINTS = {}
					end

					spawnpoint = GetTableLength(TOTAL_HERDING_POINTS) + 1
					TOTAL_HERDING_POINTS[spawnpoint] = { x = coords.x, y = coords.y, z = coords.z } -- icon = true, adjust_icon_height = 1.8, marker = true, marker_xy = { x = 3.0, y = 3.0 }, marker_rgba = {r = 255, g = 255, b = 255, a = 55}, adjust_marker_height = 0.0 }
					--returned_input_text = string.format('{ x = %s, y = %s, z = %s }', coords.x, coords.y, coords.z )

					if GetTableLength(TOTAL_HERDING_POINTS) > 0 then
							
						SendNUIMessage({ action = 'reset_herding_point_list' })

						for i = 1, GetTableLength(TOTAL_HERDING_POINTS) do

							SendNUIMessage({ 
								action             = 'insertHerdingPointListElement', 
								spawn_point_count_index = i,
								input_data         = tableToLua(TOTAL_HERDING_POINTS[i]),
							})
						end
					end
			
				end

				if action_index == 'WOLF_ATTACK_SPAWN_POINT' then 

					if TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS == nil then 
						TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS = {}
					end

					spawnpoint = GetTableLength(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS) + 1
					TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS[spawnpoint] = { model = "a_c_wolf", skin_preset = 0, x = coords.x, y = coords.y, z = coords.z, h = heading }

					if GetTableLength(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS) > 0 then
							
						SendNUIMessage({ action = 'reset_herding_wolf_attacks_list' })

						for i = 1, GetTableLength(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS) do

							SendNUIMessage({ 
								action             = 'insertHerdingWolfAttacksListElement', 
								spawn_point_count_index = i,
								input_data         = tableToLua(TOTAL_HERDING_WOLF_ATTACK_SPAWN_POINTS[i]),
							})
						end
					end
			
				end

				SetNuiFocus(true, true)
				IS_PLACEMENT_BUSY = false

			end

			if IsControlPressed(2, 0x4AF4D473) then -- Cancel
    
				SetNuiFocus(true, true)
				IS_PLACEMENT_BUSY = false

                Wait(200)
            end

		end

	end)

end)

