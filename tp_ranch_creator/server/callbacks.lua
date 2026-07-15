local API = exports.tp_libs:getAPI()

---------------------------------------------------------------
--[[ Callbacks ]]--
---------------------------------------------------------------

API.addNewCallBack("tp_ranch_creator:callbacks:getRanchDataById", function(source, cb, data)
    local _source = source
    local Ranches = exports.tp_ranch:getAPI().GetRanches()
    local ranchId = tonumber(data.ranchId)

    return cb(Ranches[ranchId])

end)
