function IsPlayerAllowlisted(currentGroup, discordRoles, groupsList, discordRolesList)

    -- We first check for groups (if available and not null)
    if currentGroup and groupsList and GetTableLength(groupsList) > 0 then

        for _, userGroup in pairs (groupsList) do
        
            if userGroup == currentGroup then
                return true
            end
      
        end

    end

    -- Secondary we check for discord roles (if available and not null)
    if ( discordRoles and GetTableLength(discordRoles) > 0 ) and ( discordRolesList and GetTableLength(discordRolesList) > 0 ) then

        for _, role in pairs (discordRolesList) do
  
            for _, userRole in pairs (discordRoles) do
              
              if tonumber(userRole) == tonumber(role) then
                return true
              end
        
            end

        end

    end

    return false
end

-- @GetTableLength returns the length of a table.
function GetTableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
