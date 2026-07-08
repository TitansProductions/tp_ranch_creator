local API = exports.tp_libs:getAPI()

---------------------------------------------------------------
--[[ Base Commands ]]--
---------------------------------------------------------------

RegisterCommand('openrancheditor', function(source, args)
    local _source = source

    local hasPermissions, await = false, true
    
    if _source ~= 0 then

        hasPermissions = IsPlayerAceAllowed(_source, "tp_ranch_creator.editor") 

        if not hasPermissions then
            local PlayerData = GetPlayerData(_source)

            hasPermissions = IsPlayerAllowlisted(PlayerData.group, PlayerData.userRoles, Config.Command.Groups, Config.Command.DiscordRoles)
        end

        await = false

    else
        hasPermissions = false -- CONSOLE DOES NOT HAVE PERMISSIONS.
        await = false
    end

    while await do
        print('3')
        Wait(100)
    end
    
    if hasPermissions then

        TriggerClientEvent("tp_ranch_creator:client:open", _source, ranchId)

    else

        if _source == 0 then
            print(Locales['NO_PERMISSIONS_COMMAND_EXECUTE'])
        else
            API.sendNotification(_source, Locales['NO_PERMISSIONS_COMMAND'], "error")
        end

    end

end, false)

---------------------------------------------------------------
--[[ Chat Events ]]--
---------------------------------------------------------------

RegisterServerEvent("tp_ranch_creator:server:addChatSuggestions")
AddEventHandler("tp_ranch_creator:server:addChatSuggestions", function()
    local _source = source
    TriggerClientEvent("chat:addSuggestion", _source, "/openrancheditor", " " .. Config.Command.Suggestion, {})
end)