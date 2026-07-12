let DEFAULT_ANIMAL_CONFIG_DATA = {};
let ANIMAL_LATEST_CONFIG_DATA = {};

function Indent(text, indent = "    ") {
  return text
    .split("\n")
    .map(line => line.length ? indent + line : line)
    .join("\n");
}


function FormatLuaValue(value) {
  if (typeof value === "string") {
    return `"${value}"`;
  }

  if (typeof value === "boolean") {
    return value ? "true" : "false";
  }

  return value;
}

function FormatLuaTable(obj, indent = "    ", wrapInArray = false) {
  const order = [
    "model",
    "skin_preset",
    "x", "y", "z", "h",
    "pitch", "roll", "yaw",
    "render_distance",
    "action_distance",
    "display_icon_distance",
    "adjust_icon_height"
  ];

  const result = [];

  // If we want to wrap this object in [1], format it again with a deeper indent
  if (wrapInArray) {
    return `${indent}[1] = {\n${FormatLuaTable(obj, indent + "    ", false)}\n${indent}},`;
  }

  for (const key of order) {
    if (obj[key] !== undefined) {
      result.push(`${indent}${key} = ${FormatLuaValue(obj[key])}`);
    }
  }

  for (const [key, value] of Object.entries(obj)) {
    if (!order.includes(key)) {
      result.push(`${indent}${key} = ${FormatLuaValue(value)}`);
    }
  }

  if (!wrapInArray) {
    return result.join(",\n");
  }

  return `        [1] = {\n${result.join(",\n")}\n        }`;
}

function FormatLua(value, indent = "        ", wrapper) {

  // Default config (single object)
  if (!Array.isArray(value)) {
    return FormatLuaTable(value, indent, wrapper);
  }

  // Latest config (array of objects)
  return value.map((obj, index) => {
    return `${indent}[${index + 1}] = {\n${FormatLuaTable(obj, indent + "    ", false)}\n${indent}}`;
  }).join(",\n");


}

function GetChickenConfigData(spawnCoords, eggSpawnCoords, feedbagStandCoords, feedingCoords, deliverFoodCoords) {

  let count = $("#animals-chicken-amount-input").val();

  let cb = `
["a_c_chicken_01"] = {

    Total = ${count},

    SpawnCoords = {
${FormatLua(spawnCoords, "        ", true)}
    },

    -- The egg spawning positions (this is the best way to handle correct spawn positions)
    -- s_gatoregg01x
    EggSpawnCoords = {
${FormatLua(eggSpawnCoords, "        ", true)}
    },

    -- The feedbag hang to pickup a feeding bucket to feed chickens.
    FeedbagStandCoords = {
${FormatLua(feedbagStandCoords, "    ", false)
      .replace(/^\s*\[\d+\]\s*=\s*{\n/, "")
      .replace(/\n\s*}$/, "")}
    },

    -- The radius to feed the chickens between player distance and @SpawnCoords
    -- DO NOT MAKE THE COORDS OR THE MAXIMUM DISTANCE BE IN THE SAME LOCATION AS THE FEEDBAG STAND!
    StartFeedingCoords = {
${FormatLua(feedingCoords, "    ", false)
      .replace(/^\s*\[\d+\]\s*=\s*{\n/, "")
      .replace(/\n\s*}$/, "")}
    },

    -- The coords to add food for the chicken.
    ChickenFoodCoords = {
${FormatLua(deliverFoodCoords, "    ", false)
      .replace(/^\s*\[\d+\]\s*=\s*{\n/, "")
      .replace(/\n\s*}$/, "")}
    },
},
`;

  return cb;

}


function GetPigConfigData(spawnCoords) {

  let count = $("#animals-pig-amount-input").val();

  let cb = `
["a_c_pig_01"] = {

    Total = ${count},

    SpawnCoords = {
${FormatLua(spawnCoords, "        ", true)}
    },

},
`;

  return cb;

}

function GetCowConfigData(spawnCoords, milkingCoords, bucketCoords, poopCoords) {

  let count = $("#animals-cow-amount-input").val();

  let cb = `
["a_c_cow"] = {

    Total = ${count},

    SpawnCoords = {
${FormatLua(spawnCoords, "        ", true)}
    },

    StartMilkingCoords = {
${FormatLua(milkingCoords, "        ", true)}
    },

    MilkBucketCoords = {
${FormatLua(bucketCoords, "        ", true)}
    },

    PoopPositions = {
${FormatLua(poopCoords, "        ", true)}
    },

},
`;

  return cb;

}

function GetGoatConfigData(spawnCoords, milkingCoords, bucketCoords, poopCoords) {

  let count = $("#animals-goat-amount-input").val();

  let cb = `
["a_c_goat_01"] = {

    Total = ${count},

    SpawnCoords = {
${FormatLua(spawnCoords, "        ", true)}
    },

    StartMilkingCoords = {
${FormatLua(milkingCoords, "        ", true)}
    },

    MilkBucketCoords = {
${FormatLua(bucketCoords, "        ", true)}
    },

    PoopPositions = {
${FormatLua(poopCoords, "        ", true)}
    },

},
`;

  return cb;

}


function GetSheepConfigData(spawnCoords, poopCoords, shearingCoords) {

  let count = $("#animals-sheep-amount-input").val();

  let cb = `
["a_c_sheep_01"] = {

    Total = ${count},

    SpawnCoords = {
${FormatLua(spawnCoords, "        ", true)}
    },

    PoopPositions = {
${FormatLua(poopCoords, "        ", true)}
    },

    TeleportPlayerShearingCoords = {
${FormatLua(shearingCoords, "        ", true)}
    },

},
`;

  return cb;

}

function GetAllAnimalConfigData() {

  let config = `Animals = {\n\n`;

  // Chicken
  {
    const latest = ANIMAL_LATEST_CONFIG_DATA.CHICKEN;
    const defaults = DEFAULT_ANIMAL_CONFIG_DATA.CHICKEN;

    config += Indent(GetChickenConfigData(
      latest?.SPAWN ?? defaults?.SPAWN,
      latest?.EGG_SPAWN ?? defaults?.EGG_SPAWN,
      latest?.FEEDBAG ?? defaults?.FEEDBAG,
      latest?.FEEDING ?? defaults?.FEEDING,
      latest?.DELIVERY ?? defaults?.DELIVERY
    ));

    config += "\n";
  }

  // Pig
  {
    const latest = ANIMAL_LATEST_CONFIG_DATA.PIG;
    const defaults = DEFAULT_ANIMAL_CONFIG_DATA.PIG;

    config += Indent(GetPigConfigData(
      latest?.SPAWN ?? defaults?.SPAWN
    ));

    config += "\n";
  }

  // Cow
  {
    const latest = ANIMAL_LATEST_CONFIG_DATA.COW;
    const defaults = DEFAULT_ANIMAL_CONFIG_DATA.COW;

    config += Indent(GetCowConfigData(
      latest?.SPAWN ?? defaults?.SPAWN,
      latest?.MILKING ?? defaults?.MILKING,
      latest?.BUCKET ?? defaults?.BUCKET,
      latest?.POOP ?? defaults?.POOP
    ));

    config += "\n";
  }

  // Goat
  {
    const latest = ANIMAL_LATEST_CONFIG_DATA.GOAT;
    const defaults = DEFAULT_ANIMAL_CONFIG_DATA.GOAT;

    config += Indent(GetGoatConfigData(
      latest?.SPAWN ?? defaults?.SPAWN,
      latest?.MILKING ?? defaults?.MILKING,
      latest?.BUCKET ?? defaults?.BUCKET,
      latest?.POOP ?? defaults?.POOP
    ));

    config += "\n";
  }

  // Sheep
  {
    const latest = ANIMAL_LATEST_CONFIG_DATA.SHEEP;
    const defaults = DEFAULT_ANIMAL_CONFIG_DATA.SHEEP;

    config += Indent(GetSheepConfigData(
      latest?.SPAWN ?? defaults?.SPAWN,
      latest?.POOP ?? defaults?.POOP,
      latest?.SHEARING ?? defaults?.SHEARING
    ));
  }

  config += "\n},";

  return config;
}
