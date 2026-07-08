local API = exports.tp_libs:getAPI()

---------------------------------------------------------------
--[[ Functions ]]--
---------------------------------------------------------------

function GetPlayerData(source)
	local _source = source

	return {
		
		identifier     = API.getIdentifier(_source),
		charIdentifier = API.getChar(_source),
        firstname      = API.getFirstName(_source), 
        lastname       = API.getLastName(_source),

		money          = API.getMoney(_source),
		gold           = API.getGold(_source),
		job            = API.getJob(_source),

		group          = API.getGroup(_source),

		steamName      = GetPlayerName(_source),
	}

end


---------------------------------------------------------------
--[[ Events ]]--
---------------------------------------------------------------
