Config = {}

Config.Debug = false

-- Notifications while having the NUI is active.
Config.NotificationColors = { 
  ['error']   = "rgb(255, 0, 0, 0.79)",
  ['success'] = "rgb(0, 255, 0, 0.79)",
  ['info']    = "rgb(102, 178, 255, 0.79)"
}

--[[ ------------------------------------------------
  General
]]---------------------------------------------------

-- (!) Checkout client/nui.lua for adding more keys manually.
Config.HorseWhistleKey = 0x24978A28 -- (H BY DEFAULT)

-- (!) Checkout client/nui.lua for adding more keys manually.
Config.WagonWhistleKey = 0xF3830D8E --  (J BY DEFAULT)

-- What should be the max distance to display herding points ?
Config.RenderHerdingPointDistance = 20.0

-- Display herding action circular markers?
Config.HerdingActionMarkers = {
  Enabled = true,

  Distance = 5.0,
  RGBA = {r = 0, g = 123, b = 255, a = 55},
}

-- Display herding action circular markers?
Config.HerdingWolfActionMarkers = {
  Enabled = true,

  Distance = 5.0,
  RGBA = {r = 155, g = 0, b = 0, a = 55},
}


--[[ ------------------------------------------------
  Commands
]]---------------------------------------------------

Config.Command = { -- /openrancheditor

  Suggestion = "Perform this command to open the ranch editor for creating new ranches.",

  -- The discord roles to execute this command.
  DiscordRoles = { 670899926783361024, 1174077274153299988 },

  -- The discord roles to execute this command.
  Groups = { 'admin' }

}
