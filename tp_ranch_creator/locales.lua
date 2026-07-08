Locales = {}

Locales = {

	['NUI_MAIN_ACCOUNT_TITLE']      = "Ranch Creator",
	['NUI_MAIN_ACCOUNT_TITLE_DESC'] = "Create or edit a ranch by editing all the sections and once finished, retrieve ranch data to be used on the config_ranches.lua",

	['MENU_BUTTON_COST']            = "Set Buy Cost",
	['MENU_BUTTON_REQUIRED_JOBS']   = "Members Required Jobs",
	['MENU_BUTTON_MAIN_COORDS']     = "Management Menu Coords",
	['MENU_BUTTON_ANIMAL_STORE']    = "Animal Store",
	['MENU_BUTTON_MILK_CONTAINER']  = "Milk Jug Container",
	['MENU_BUTTON_WATER_BARREL']    = "Water Barrel",
	['MENU_BUTTON_HAY_BARREL']      = "Hay Food",
	['MENU_BUTTON_PITCH_FORK']      = "Pitch Fork",
	['MENU_BUTTON_CAULDRON']        = "Cauldron",
	['MENU_BUTTON_ANIMALS']         = "Animals & Spawn Positions",
	['MENU_BUTTON_GET_DATA']        = "Get Config Data",
	['MENU_BUTTON_EXIT']            = "Exit",
	['MENU_BUTTON_BACK']            = "Go Back",
	['MENU_RETRIEVE_CONFIG_DATA_BUTTON'] = "Get Config Data",

	['MENU_ANIMAL_SECTION_BUTTON_COW']      = "Cow",
	['MENU_ANIMAL_SECTION_BUTTON_GOAT']     = "Goat",
	['MENU_ANIMAL_SECTION_BUTTON_SHEEP']    = "Sheep",
	['MENU_ANIMAL_SECTION_BUTTON_CHICKEN']  = "Chicken",
	['MENU_ANIMAL_SECTION_BUTTON_PIG']      = "Pig",

	/* COST SECTION */
	['NUI_COST_SECTION_METHOD_DESC'] = "Insert a valid payment method (GOLD, CASH or item name if the payment method is an item).",
	['NUI_COST_SECTION_DESC']        = "Insert a valid cost amount for buying the ranch.",
	['NUI_COST_SECTION_ITEM_DESC']   = "Should the payment method be an item or a currency?\n\n If the payment method is an item, insert on the above input field the item name instead of the currency type.",

	/* REQUIRED JOBS SECTION */
	['NUI_REQUIRED_JOBS_DESC']       = "Would you like to allow specific jobs for the ranch owner to invite employees / members to the ranch?\n\nIf yes, set the desired jobs on the input field such as : firstjob, secondjob - (a comma must be inserted), otherwise keep it as it is. If a comma is not placed on every job, the result will return invalid.",

	['NO_PERMISSIONS_COMMAND'] = "~e~You have insufficient permissions to perform this command.",
	['NO_PERMISSIONS_COMMAND_EXECUTE'] = "^1You cannot use this command through txadmin / console.^7",

	/* MAIN COORDS SECTION */
	['NUI_MAIN_COORDS_DESC']           = "Click the button below to add the desired coords through a game action(s).",
	['NUI_MAIN_COORDS_BUTTON']         = "Set In-Game Coords",

	/* ANIMAL STORE SECTION */

	['NUI_ANIMAL_STORE_DESC']          = "Enable or disable animal types that will be able to be purchased from the management menu store and be used on the ranch.\n\nIf an animal type is allowed, it must be having spawn positions available on the ranch related to this type.",

	['NUI_ANIMAL_STORE_CHICKEN_DESC']  = "Allow chicken: ",
	['NUI_ANIMAL_STORE_SHEEP_DESC']  = "Allow sheep: ",
	['NUI_ANIMAL_STORE_COW_DESC']  = "Allow cows: ",
	['NUI_ANIMAL_STORE_GOAT_DESC']  = "Allow goats: ",
	['NUI_ANIMAL_STORE_PIG_DESC']  = "Allow pigs: ",

	/* MILK CONTAINER JUG SECTION */

	['NUI_MILK_CONTAINER_ACCESS_DESC']    = "The coordinates for accessing the milk jug container, you can insert the coords through a game action(s).",
	['NUI_MILK_CONTAINER_DELIVER_DESC']   = "The coordinates for delivering the milk, you can insert the coords through a game action(s).",
	['NUI_MILK_CONTAINER_ACCESS_BUTTON']  = "Set In-Game Coords",
	['NUI_MILK_CONTAINER_DELIVER_BUTTON'] = "Set In-Game Coords",

	/* WATER BARREL SECTION */

	['NUI_WATER_BARREL_DESC'] = "The placement of the water barrel, including the position where to deposit water for increasing its storage capacity. The water barrel is required for the animals water / thirst consumption system if active.\n\nYou can insert the coords through a game action(s).",
	['NUI_WATER_BARREL_BUTTON'] = "Set In-Game Coords",

	/* HAY SECTION */

	['NUI_HAY_DESC'] = "The position where to deposit food (if item system is active) or deliver hay for increasing its animal feeding capacity. The hay food is required for the goats and cows food / hunger consumption system.\n\nYou can insert the coords through a game action(s).",
	['NUI_HAY_ICON_DESC'] = "Would you like to display an icon above hay position when delivering hay? (If item system is disabled).",
	['NUI_HAY_BUTTON'] = "Set In-Game Coords",

	/* PITCHFORK SECTION */

	['NUI_PITCHFORK_DESC'] = "The placement of the pitch fork, the pitchfork object placement is required to pickup poop from cows, goats or sheep to make a fertilizer.\n\nYou can insert the coords through a game action(s).",
	['NUI_PITCHFORK_BUTTON'] = "Set In-Game Coords",

	/* CAULDRON SECTION */

	['NUI_CAULDRON_DESC']   = "The placement of the cauldron, the cauldron object placement is required to deliver the picked up poop from the pitchfork to make a fertilizer.\n\nYou can insert the coords through a game action(s).",
	['NUI_CAULDRON_BUTTON'] = "Set In-Game Coords",
	['NUI_CAULDRON_TELEPORT_DESC']   = "Set the desired coords through a game action(s) for the player to be teleported in the correct position for performing animation on the cauldron object.",
	['NUI_CAULDRON_TELEPORT_BUTTON'] = "Set In-Game Coords",


	/* COW SECTION */

	['NUI_COW_AMOUNT_DESCRIPTION']         = "How many cows would you like the ranch to contain? Set to O if it does not contain any cows currently.",
	['NUI_COW_SPAWN_BUTTON']               = "Spawn Points",
	['NUI_COW_SPAWN_DESC']                 = "Add spawnpoint(s) for the cows spawning based on the count the ranch can contain. To increase or decrease the spawning amount of cows, go to the previous page and set the desired amount of cows to be spawned on the ranch.",

	['NUI_COW_MILKING_ACTION_BUTTON']      = "Milking Action Positions",
	['NUI_COW_MILKING_ACTION_DESC']        = "Add the positions for cow milking based on every cow separately. This is required to perform the animations perfectly.",

	['NUI_COW_MILKING_BUCKET_BUTTON']      = "Milking Bucket Positions",
	['NUI_COW_MILKING_BUCKET_DESC']        = "Add the milk bucket positions on below the spawned cows where the tits are located in order to spawn the bucket properly once the player starts milking.",

	['NUI_COW_SPAWN_POOP_BUTTON']          = "Poop Spawn Points",
	['NUI_COW_SPAWN_POOP_DESC']            = "Add the spawned poop positions on the back of the spawned cows in order for the player to pick them up with the pitchfork properly.",
	
	['NUI_COW_NOT_COUNT_AVAILABLE']        = "You don't have any cows available for spawning, to have any actions available related to this section you need to increase the cows count in the previous page.",

	/* GOAT SECTION */

	['NUI_GOAT_AMOUNT_DESCRIPTION']         = "How many goats would you like the ranch to contain? Set to O if it does not contain any goats currently.",
	['NUI_GOAT_SPAWN_BUTTON']               = "Spawn Points",
	['NUI_GOAT_SPAWN_DESC']                 = "Add spawnpoint(s) for the goats spawning based on the count the ranch can contain. To increase or decrease the spawning amount of goats, go to the previous page and set the desired amount of goats to be spawned on the ranch.",
	['NUI_GOAT_MILKING_ACTION_BUTTON']      = "Milking Action Positions",
	['NUI_GOAT_MILKING_ACTION_DESC']        = "Add the positions for goat milking based on every goat separately. This is required to perform the animations perfectly.",

	['NUI_GOAT_MILKING_BUCKET_BUTTON']      = "Milking Bucket Positions",
	['NUI_GOAT_MILKING_BUCKET_DESC']        = "Add the milk bucket positions on below the spawned goats where the tits are located in order to spawn the bucket properly once the player starts milking.",

	['NUI_GOAT_SPAWN_POOP_BUTTON']          = "Poop Spawn Points",
	['NUI_GOAT_SPAWN_POOP_DESC']            = "Add the spawned poop positions on the back of the spawned goats in order for the player to pick them up with the pitchfork properly.",

	['NUI_GOAT_NOT_COUNT_AVAILABLE']        = "You don't have any goats available for spawning, to have any actions available related to this section you need to increase the goats count in the previous page.",


	/* SHEEP SECTION */

	['NUI_SHEEP_AMOUNT_DESCRIPTION']         = "How many sheep would you like the ranch to contain? Set to O if it does not contain any sheep currently.",
	['NUI_SHEEP_SPAWN_BUTTON']               = "Spawn Points",
	['NUI_SHEEP_SPAWN_DESC']                 = "Add spawnpoint(s) for the sheep spawning based on the count the ranch can contain. To increase or decrease the spawning amount of sheep, go to the previous page and set the desired amount of sheep to be spawned on the ranch.",

	['NUI_SHEEP_SHEARING_ACTION_BUTTON']     = "Shearing Action Positions",
	['NUI_SHEEP_SHEARING_ACTION_DESC']       = "Add positions on every sheep separately where the players are going to perform the shearing animation - make sure the player position faces the sheep perfectly.",

	['NUI_SHEEP_SPAWN_POOP_BUTTON']          = "Poop Spawn Points",
	['NUI_SHEEP_SPAWN_POOP_DESC']            = "Add the spawned poop positions on the back of the spawned sheep in order for the player to pick them up with the pitchfork properly.",
	
	['NUI_SHEEP_NOT_COUNT_AVAILABLE']        = "You don't have any sheep available for spawning, to have any actions available related to this section you need to increase the sheep count in the previous page.",

	/* CHICKEN SECTION */

	['NUI_CHICKEN_AMOUNT_DESCRIPTION']         = "How many sheep would you like the ranch to contain? Set O if it does not contain any sheep currently.",
	['NUI_CHICKEN_SPAWN_BUTTON']               = "Spawn Points",
	['NUI_CHICKEN_SPAWN_DESC']                 = "Add spawnpoint(s) for the chickens spawning based on the count the ranch can contain. To increase or decrease the spawning amount of chickens, go to the previous page and set the desired amount of chickens to be spawned on the ranch.",
	
	
	['NUI_CHICKEN_EGG_SPAWN_BUTTON']           = "Egg Spawn Points",
	['NUI_CHICKEN_EGG_SPAWN_DESC']             = "Add spawnpoint(s) for the chicken eggs, you can have unlimited spawn points for spawning the chicken eggs - suggested is to have by default many positions (20 - 30+)",
	
	['NUI_CHICKEN_FEEDBAG_BUTTON']             = "Feedbag Placement",
	['NUI_CHICKEN_FEEDBAG_DESC']               = "Add the placement of the feedbag object position where you can get the corn for feeding the chicken.\n\nThere is only (1) position for placing the feedbag to feed the chicken.",
	
	['NUI_CHICKEN_FEEDING_BUTTON']             = "Feeding Coords",
	['NUI_CHICKEN_FEEDING_DESC']               = "Add the position where the player will be able to feed the chicken (like a feeding spot).\n\nThere is only (1) position for feeding the chicken.",
	
	['NUI_CHICKEN_CORN_DELIVERY_BUTTON']       = "Corn Food Delivery Coords",
	['NUI_CHICKEN_CORN_DELIVERY_DESC']         = "Add the position where the player will deliver corn for increasing the feeding capacity of the feedbag.\n\nThere is only (1) position for delivering the corn.",

	['NUI_CHICKEN_NOT_COUNT_AVAILABLE']        = "You don't have any chickens available for spawning, to have any actions available related to this section you need to increase the chicken count in the previous page.",

	/* PIG SECTION */

	['NUI_PIG_AMOUNT_DESCRIPTION']         = "How many pigs would you like the ranch to contain? Set to O if it does not contain any pigs currently.",
	['NUI_PIG_SPAWN_BUTTON']               = "Spawn Points",
	['NUI_PIG_SPAWN_DESC']                 = "Add spawnpoint(s) for the pigs spawning based on the count the ranch can contain. To increase or decrease the spawning amount of pigs, go to the previous page and set the desired amount of pigs to be spawned on the ranch.",

	['NUI_PIG_NOT_COUNT_AVAILABLE']        = "You don't have any pigs available for spawning, to have any actions available related to this section you need to increase the pigs count in the previous page.",

	/* EXIT DIALOG */
	['NUI_CLOSE_DIALOG_DESC'] = "Are you sure you want to close the creator? You will lose all progress.",
	['NUI_CLOSE_DIALOG_ACCEPT_BUTTON'] = "Accept & Close",
	['NUI_CLOSE_DIALOG_CANCEL_BUTTON'] = "Cancel",

	/* OTHER */
	['PRESS_DISPLAY_ON_BUILDER_SUCCESS']      = "Press ~o~Enter~q~ to set the desired position",
	['PRESS_DISPLAY_ON_BUILDER_CANCEL']       = "Press ~o~Delete~q~ to cancel action",
	['NUI_ANIMALS_ACTIONS_SET_SPAWN_POINT']   = "Set Spawnpoint",
	['NUI_ANIMALS_ACTIONS_SET_POSITION']      = "Set Position",
	['NUI_ANIMALS_ACTIONS_EDIT_POSITION']     = "Edit Position",
	['NUI_ANIMALS_ACTIONS_CREATE_POSITION']   = "Create New Position",
}