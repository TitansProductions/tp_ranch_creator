let OPENED_SECTION_INDEX_NAME = null;
let OPENED_SECTION_INDEX_CLASS_NAME = null;
let OPENED_SECTION_ANIMAL_INDEX_NAME = null;
let OPENED_SECTION_ANIMAL_CLASS_NAME = null;
let OPENED_SECTION_HERDING_INDEX_NAME = null;
let OPENED_SECTION_HERDING_CLASS_NAME = null;
let RETRIEVED_CLASS_CONFIG_DATA = "";
let SELECTED_ANIMAL_TYPE_SECTION = null;
let SELECTED_ANIMAL_TYPE = null;
let SELECTED_ANIMAL_ACTION_TYPE = null;

let HERDING_LATEST_SPAWN_POINTS_CONFIG_DATA = null;
let HERDING_LATEST_HERDING_POINTS_CONFIG_DATA = null;
let HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA = null;

function CloseNUI() {
  $("#main").fadeOut();
  HideAll();
  ClearAll();

  $.post('http://tp_ranch_creator/close', JSON.stringify({}));
}


$(function () {

  window.addEventListener('message', function (event) {

    var item = event.data;

    if (item.type == "enable") {

      OPENED_SECTION_INDEX_NAME = null;

      if (item.enable) {
        document.body.style.display = item.enable ? "block" : "none";

      } else {

        HideAll();

        $("#main").fadeOut(1000);

      }

      if (item.enable) {

        if (item.window == 'main') {

          $("#main").fadeIn(1000);

        }

      }

    } else if (item.action == "insertLocales") {

      $("#main-title").text(item.locales['NUI_MAIN_ACCOUNT_TITLE']);
      $("#main-title-description").text(item.locales['NUI_MAIN_ACCOUNT_TITLE_DESC']);
      $("#main-back-button").text(item.locales['MENU_BUTTON_BACK']);
      $("#main-exit-button").text(item.locales['MENU_BUTTON_EXIT']);
      $("#main-config-data-button").text(item.locales['MENU_RETRIEVE_CONFIG_DATA_BUTTON']);
      $("#main-all-config-data-button").text(item.locales['MENU_RETRIEVE_CONFIG_DATA_BUTTON']);
      $("#exit-dialog-description").text(item.locales['NUI_CLOSE_DIALOG_DESC']);
      $("#exit-dialog-accept-button").text(item.locales['NUI_CLOSE_DIALOG_ACCEPT_BUTTON']);
      $("#exit-dialog-cancel-button").text(item.locales['NUI_CLOSE_DIALOG_CANCEL_BUTTON']);


      $("#main-cost-description").text(item.locales['NUI_COST_SECTION_DESC']);
      $("#main-cost-method-description").text(item.locales['NUI_COST_SECTION_METHOD_DESC']);
      $("#main-cost-item-method-description").text(item.locales['NUI_COST_SECTION_ITEM_DESC']);

      $("#main-required-jobs-description").text(item.locales['NUI_REQUIRED_JOBS_DESC']);

      $("#main-coords-description").text(item.locales['NUI_MAIN_COORDS_DESC']);
      $("#main-coords-position-button").text(item.locales['NUI_MAIN_COORDS_BUTTON']);


      $("#animal-store-description").text(item.locales['NUI_ANIMAL_STORE_DESC']);
      $("#animal-store-chicken-description").text(item.locales['NUI_ANIMAL_STORE_CHICKEN_DESC']);
      $("#animal-store-sheep-description").text(item.locales['NUI_ANIMAL_STORE_SHEEP_DESC']);
      $("#animal-store-cow-description").text(item.locales['NUI_ANIMAL_STORE_COW_DESC']);
      $("#animal-store-goat-description").text(item.locales['NUI_ANIMAL_STORE_GOAT_DESC']);
      $("#animal-store-pig-description").text(item.locales['NUI_ANIMAL_STORE_PIG_DESC']);

      $("#milk-container-access-description").text(item.locales['NUI_MILK_CONTAINER_ACCESS_DESC']);
      $("#milk-container-deliver-description").text(item.locales['NUI_MILK_CONTAINER_DELIVER_DESC']);

      $("#milk-container-position-button").text(item.locales['NUI_MILK_CONTAINER_ACCESS_BUTTON']);
      $("#milk-container-deliver-button").text(item.locales['NUI_MILK_CONTAINER_DELIVER_BUTTON']);

      $("#water-barrel-description").text(item.locales['NUI_WATER_BARREL_DESC']);
      $("#water-barrel-position-button").text(item.locales['NUI_WATER_BARREL_BUTTON']);

      $("#hay-barrel-description").text(item.locales['NUI_HAY_DESC']);
      $("#hay-barrel-position-button").text(item.locales['NUI_HAY_BUTTON']);
      $("#hay-barrel-icon-description").text(item.locales['NUI_HAY_ICON_DESC']);

      $("#pitch-fork-description").text(item.locales['NUI_PITCHFORK_DESC']);
      $("#pitch-fork-position-button").text(item.locales['NUI_PITCHFORK_BUTTON']);

      $("#cauldron-description").text(item.locales['NUI_CAULDRON_DESC']);
      $("#cauldron-position-button").text(item.locales['NUI_CAULDRON_BUTTON']);
      $("#cauldron-teleport-description").text(item.locales['NUI_CAULDRON_TELEPORT_DESC']);
      $("#cauldron-teleport-button").text(item.locales['NUI_CAULDRON_TELEPORT_BUTTON']);

      $("#animals-cow-amount-description").text(item.locales['NUI_COW_AMOUNT_DESCRIPTION']);
      $("#animals-cow-back-button").text(item.locales['MENU_BUTTON_BACK']);

      $("#animals-goat-amount-description").text(item.locales['NUI_GOAT_AMOUNT_DESCRIPTION']);
      $("#animals-goat-back-button").text(item.locales['MENU_BUTTON_BACK']);

      $("#animals-sheep-amount-description").text(item.locales['NUI_SHEEP_AMOUNT_DESCRIPTION']);
      $("#animals-sheep-back-button").text(item.locales['MENU_BUTTON_BACK']);

      $("#animals-chicken-amount-description").text(item.locales['NUI_CHICKEN_AMOUNT_DESCRIPTION']);
      $("#animals-chicken-back-button").text(item.locales['MENU_BUTTON_BACK']);

      $("#animals-pig-amount-description").text(item.locales['NUI_PIG_AMOUNT_DESCRIPTION']);
      $("#animals-pig-back-button").text(item.locales['MENU_BUTTON_BACK']);

      $("#animals-actions-back-button").text(item.locales['MENU_BUTTON_BACK']);
      $("#animals-actions-create-button").text(item.locales['NUI_ANIMALS_ACTIONS_CREATE_POSITION']);

      $("#herding-description").text(item.locales['NUI_HERDING_DESCRIPTION']);
      $("#herding-spawn-points-description").text(item.locales['NUI_HERDING_SPAWN_POINTS_DESCRIPTION']);
      $("#herding-spawn-points-back-button").text(item.locales['MENU_BUTTON_BACK']);

      $("#herding-herding-create-button").text(item.locales['NUI_HERDING_POINTS_CREATE_POSITION']);
      $("#herding-herding-back-button").text(item.locales['MENU_BUTTON_BACK']);

      $("#herding-wolf-attacks-create-button").text(item.locales['NUI_HERDING_POINTS_CREATE_POSITION']);
      $("#herding-wolf-attacks-back-button").text(item.locales['MENU_BUTTON_BACK']);

    } else if (item.action == "insertButton") {

      let progress = 0;
      let color = ""

      switch (item.action_index) {

        case "COST":

          if ($("#main-cost-method-input").val().trim() !== "") {
            progress += 50;
          }

          if ($("#main-cost-input").val().trim() !== "") {
            progress += 50;
          }

          break;

        case "REQUIRED_JOBS":

          if ($("#main-required-jobs-input").val().trim() !== "") {
            progress += 100;
          }

          break;


        case "MAIN_COORDS":

          const coords = $("#main-coords-position-input").val().trim();

          const isVector = /^vector3\s*\(\s*-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?\s*\)$/i.test(coords);
          const isZeroVector = /^vector3\s*\(\s*0+(\.0+)?\s*,\s*0+(\.0+)?\s*,\s*0+(\.0+)?\s*\)$/i.test(coords);

          if (coords !== "" && isVector && !isZeroVector) {
            progress += 100;
          }
          break;


        case "ANIMAL_STORE":

          const animalConfig = [
            { id: "animal-store-chicken-switch", name: "a_c_chicken_01" },
            { id: "animal-store-sheep-switch", name: "a_c_sheep_01" },
            { id: "animal-store-cow-switch", name: "a_c_cow" },
            { id: "animal-store-goat-switch", name: "a_c_goat_01" },
            { id: "animal-store-pig-switch", name: "a_c_pig_01" }
          ];

          progress = animalConfig.some(animal =>
            document.getElementById(animal.id).checked
          ) ? 100 : 0;

          break;

        case "MILK_CONTAINER":
          const milkContainerAccess = $("#milk-container-position-input").val().trim();
          const milkDelivery = $("#milk-container-deliver-input").val().trim();

          const defaultMilkContainerAccess =
            "{ x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0, render_distance = 20.0 }";

          const defaultMilkDelivery =
            "{ x = 0, y = 0, z = 0, action_distance = 0.9 }";

          if (
            milkContainerAccess !== "" &&
            milkContainerAccess !== defaultMilkContainerAccess
          ) {
            progress += 50;
          }

          if (
            milkDelivery !== "" &&
            milkDelivery !== defaultMilkDelivery
          ) {
            progress += 50;
          }

          break;

        case "WATER_BARREL":
          const waterBarrel = $("#water-barrel-position-input").val().trim();

          const defaultWaterBarrel =
            "{ x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0, render_distance = 20.0 }";

          if (
            waterBarrel !== "" &&
            waterBarrel !== defaultWaterBarrel
          ) {
            progress += 100;
          }

          break;

        case "HAY_BARREL":
          const hayBarrel = $("#hay-barrel-position-input").val().trim();

          const defaultHayBarrel =
            "{ x = 0, y = 0, z = 0 }";

          if (
            hayBarrel !== "" &&
            hayBarrel !== defaultHayBarrel
          ) {
            progress += 100;
          }

          break;

        case "PITCH_FORK":
          const pitchFork = $("#pitch-fork-position-input").val().trim();

          const defaultPitchFork =
            "{ x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0 }";

          if (
            pitchFork !== "" &&
            pitchFork !== defaultPitchFork
          ) {
            progress += 100;
          }

          break;

        case "CAULDRON":
          const cauldron1 = $("#cauldron-position-input").val().trim();
          const cauldron2 = $("#cauldron-teleport-input").val().trim();

          const defaultCauldron1 =
            '{ object = "p_cauldron01x", x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0 }';

          const defaultCauldron2 =
            '{ x = 0, y = 0, z = 0, h = 0 }';

          if (
            cauldron1 !== "" &&
            cauldron1 !== defaultCauldron1
          ) {
            progress += 50;
          }

          if (
            cauldron2 !== "" &&
            cauldron2 !== defaultCauldron2
          ) {
            progress += 50;
          }

          break;

      }


      let progressColor = "";

      switch (progress) {
        case 0:
          progressColor = "#dc3545"; // Red
          break;
        case 30:
          progressColor = "#fd7e14"; // Orange
          break;
        case 50:
          progressColor = "#ffc107"; // Yellow
          break;
        case 70:
          progressColor = "#0dcaf0"; // Light Blue
          break;
        case 100:
          progressColor = "#198754"; // Green
          break;
      }

      if (item.action_index != 'ANIMALS' && item.action_index != "HERDING") {
        $("#main-buttons-list").append(
          `<div class="main-buttons-list-button ${item.action_index}" data-button="${item.action_index}">` +
          `<div class="main-buttons-list-label">${item.locale}</div>` +
          `<div class="main-buttons-list-progress" style="color: ${progressColor};">${progress}%</div>` +
          `</div>`
        );
      } else {
        $("#main-buttons-list").append(
          `<div class="main-buttons-list-button ${item.action_index}" data-button="${item.action_index}">` +
          `<div class="main-buttons-list-label">${item.locale}</div>` +
          `</div>`
        );
      }


    } else if (item.action == 'insertAnimalSectionButton') {

      $("#animals-buttons-list").append(
        `<div class="animals-buttons-list-button ${item.action_index}" data-button="${item.action_index}">` +
        `<div class="animals-buttons-list-label">${item.locale}</div>` +
        //`<div class="animals-buttons-list-progress" style="color: ${progressColor};">${progress}%</div>` +
        `</div>`
      );

    } else if (item.action == 'insertHerdingSectionButton') {

      $("#herding-buttons-list").append(
        `<div class="herding-buttons-list-button ${item.action_index}" data-button="${item.action_index}">` +
        `<div class="herding-buttons-list-label">${item.locale}</div>` +
        //`<div class="animals-buttons-list-progress" style="color: ${progressColor};">${progress}%</div>` +
        `</div>`
      );

    } else if (item.action == 'insertAnimalTypeSectionButton') {

      $("#" + item.list_class).append(
        `<div class="${item.list_class}-button ${item.action_index}" data-button="${item.action_index}">` +
        `<div class="${item.list_class}-label">${item.locale}</div>` +
        //`<div class="animals-buttons-list-progress" style="color: ${progressColor};">${progress}%</div>` +
        `</div>`
      );

    } else if (item.action == 'reset_buttons') {

      $("#main-buttons-list").html("");

    } else if (item.action == 'reset_animal_section_buttons') {

      $("#animals-buttons-list").html("");

    } else if (item.action == 'reset_herding_section_buttons') {

      $("#herding-buttons-list").html("");


    } else if (item.action == 'updateHerdingInputByName') {

      $(item.input_name).val(item.returned_input_text);

    } else if (item.action == 'updateInputByName') {

      $(item.input_name).val(item.returned_input_text);

      if (item.is_animal_section) {
        $("#animals-actions-list-default-" + item.animal_count)
          .attr("class", "fa-solid fa-check")
          .css("color", "#5e9c63");
      }

      $(".placement-info").fadeOut(); // requires placement info

    } else if (item.action == 'hide_builder_info') {

      $(".placement-info").fadeOut(); // requires placement info

    } else if (item.action == 'displayAnimalActionsSection') {

      $("#animals-actions-list").html("");

      $('#animals-actions-description').text(item.description);
      $('#animals-actions-description').css('color', item.color + ';');

      $("#main-config-data-button").hide();
      $(".animals-actions").fadeIn();


    } else if (item.action == 'displayHerdingSpawnPointsSection') {

      $('#herding-spawn-points-description').text(item.description);
      $('#herding-spawn-points-description').css('color', item.color + ';');

    } else if (item.action == 'displayHerdingPointsSection') {

      $('#herding-herding-description').text(item.description);
      $('#herding-herding-description').css('color', item.color + ';');

      $("#herding-herding-create-button").toggle(item.allowed);

    } else if (item.action == 'displayHerdingWolfAttacksPointsSection') {

      $('#herding-wolf-attacks-description').text(item.description);
      $('#herding-wolf-attacks-description').css('color', item.color + ';');

      $('#herding-wolf-attacks-chance-description').text(item.description2);

      $("#herding-wolf-attacks-create-button").toggle(item.allowed);
      $("#herding-wolf-attacks-chance-input").toggle(item.allowed);
      $("#herding-wolf-attacks-enable-label").toggle(item.allowed);
      $("#herding-wolf-attacks-disable-label").toggle(item.allowed);

    } else if (item.action == 'insertSelectedAnimalTypeActionListElement') {

      let currentValue = item.input_data;

      let isDefault = item.is_default
        ? ''
        : 'class="fa-solid fa-check" style="color: #5e9c63;"';

      $("#animals-actions-list").append(
        `<div class="animals-actions-list-main">` +
        `<div class="animals-actions-list-label">#${item.animal_count_index}</div>` +
        `<div id="animals-actions-list-default-${item.animal_count_index}" ${isDefault}></div>` +
        `<input class="animals-actions-list-input-${item.animal_count_index}" id="animals-actions-list-input" value = "${currentValue}" readonly></input>` +
        `<div class="animals-actions-list-button" data-animal-count="${item.animal_count_index}">${item.button_locale}</div>` +
        `</div>`
      );

    } else if (item.action == 'insertHerdingSpawnPointListElement') {
      let currentValue = item.input_data;

      let isDefault = item.is_default
        ? ''
        : 'class="fa-solid fa-check" style="color: #5e9c63;"';

      $("#herding-spawn-points-list").append(
        `<div class="herding-spawn-points-list-main">` +
        `<div class="herding-spawn-points-list-label">#${item.spawn_point_count_index}</div>` +
        `<div id="herding-spawn-points-list-default-${item.spawn_point_count_index}" ${isDefault}></div>` +
        `<input class="herding-spawn-points-list-input-${item.spawn_point_count_index}" id="herding-spawn-points-list-input" value = "${currentValue}" readonly></input>` +
        `<div class="herding-spawn-points-list-button" data-spawnpoint-count="${item.spawn_point_count_index}">${item.button_locale}</div>` +
        `</div>`
      );

    } else if (item.action == 'reset_herding_point_list') {

      $("#herding-herding-list").html("");

    } else if (item.action == 'reset_herding_wolf_attacks_list') {

      $("#herding-wolf-attacks-list").html("");

    } else if (item.action == 'insertHerdingPointListElement') {

      let currentValue = item.input_data;
      let deleteButton = 'class="fa-solid fa-x" style="color: #9c5e5e;"';

      $("#herding-herding-list").append(
        `<div class="herding-herding-list-main">` +
        `<div class="herding-herding-list-label">#${item.spawn_point_count_index}</div>` +
        `<div
        id="herding-herding-list-delete-${item.spawn_point_count_index}"
        onmouseover="this.style.color='rgb(167,39,39)'"
        onmouseout="this.style.color='#9c5e5e'"
        ${deleteButton}
    ></div>` +
        `<input class="herding-herding-list-input-${item.spawn_point_count_index}" id="herding-herding-list-input" value = "${currentValue}" readonly></input>` +
        `</div>`
      );

    } else if (item.action == 'insertHerdingWolfAttacksListElement') {

      let currentValue = item.input_data.replace(/"/g, "&quot;");
      let deleteButton = 'class="fa-solid fa-x" style="color: #9c5e5e;"';

      $("#herding-wolf-attacks-list").append(
        `<div class="herding-wolf-attacks-list-main">` +
        `<div class="herding-wolf-attacks-list-label">#${item.spawn_point_count_index}</div>` +
        `<div
        id="herding-wolf-attacks-list-delete-${item.spawn_point_count_index}"
        onmouseover="this.style.color='rgb(167,39,39)'"
        onmouseout="this.style.color='#9c5e5e'"
        ${deleteButton}
    ></div>` +
        `<input class="herding-wolf-attacks-list-input-${item.spawn_point_count_index}" id="herding-wolf-attacks-list-input" value = "${currentValue}" readonly></input>` +
        `</div>`
      );

    } else if (item.action == 'displayActionsCreateButton') {

      $("#animals-actions-create-button").show();

    } else if (item.action == 'insertSelectedAnimalTypeEggActionListElement') {

      let currentValue = item.input_data;
      let deleteButton = 'class="fa-solid fa-x" style="color: #9c5e5e;"';

      $("#animals-actions-list").append(
        `<div class="animals-actions-list-main">` +
        `<div class="animals-actions-list-label">#${item.animal_count_index}</div>` +
        `<div
        id="animals-actions-list-delete-${item.animal_count_index}"
        onmouseover="this.style.color='rgb(167,39,39)'"
        onmouseout="this.style.color='#9c5e5e'"
        ${deleteButton}
    ></div>` +
        `<input class="animals-actions-list-input-${item.animal_count_index}" id="animals-actions-list-input" value = "${currentValue}" readonly></input>` +
        `<div class="animals-actions-list-button" data-animal-count="${item.animal_count_index}">${item.button_locale}</div>` +
        `</div>`
      );

    } else if (item.action == 'resetActionsList') {

      $("#animals-actions-list").html('');

    } else if (item.action == 'sendLatestSelectedAnimalConfigData') {

      DEFAULT_ANIMAL_CONFIG_DATA[item.animal] = item.default_config_data;
      ANIMAL_LATEST_CONFIG_DATA[item.animal] = item.config_data;

    } else if (item.action == 'sendLatestHerdingPointsConfigData') {

      HERDING_LATEST_HERDING_POINTS_CONFIG_DATA = item.config_data;

    } else if (item.action == 'sendLatestHerdingSpawnPointsConfigData') {

      HERDING_LATEST_SPAWN_POINTS_CONFIG_DATA = item.config_data;

    } else if (item.action == 'sendLatestHerdingWolfAttacksConfigData') {

      HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA = item.config_data;

    } else if (item.action == 'displayAllConfigData') {

      OpenConfigData();

    } else if (item.action == "sendNotification") {
      let prod_notify = item.notification_data;
      SendNotification(prod_notify.message, prod_notify.color, prod_notify.duration);

    } else if (item.action == "close") {
      CloseNUI();

    }

  });

  /* ------------------------------------------------
  ------------------------------------------------ */

  $("#main").on("click", "#herding-wolf-attacks-create-button", function () {
    PlayButtonClickSound();

    $.post('http://tp_ranch_creator/startHerdingPointPlacement', JSON.stringify({
      action_index: 'WOLF_ATTACK_SPAWN_POINT',
    }));

  });

  $("#main").on("click", "#herding-herding-create-button", function () {
    PlayButtonClickSound();

    $.post('http://tp_ranch_creator/startHerdingPointPlacement', JSON.stringify({
      action_index: 'HERDING_POINT',
    }));

  });

  $("#main").on("click", ".herding-spawn-points-list-button", function () {
    PlayButtonClickSound();

    const spawnpoint = $(this).data("spawnpoint-count");


    $.post('http://tp_ranch_creator/startHerdingPointPlacement', JSON.stringify({
      action_index: 'SPAWN_POINT',
      spawnpoint: spawnpoint,
      input_class_index: ".herding-spawn-points-list-input-" + spawnpoint,
    }));

  });

  $(document).on("click", "[id^='herding-herding-list-delete-']", function () {
    const index = this.id.replace("herding-herding-list-delete-", "");
    PlayButtonClickSound();

    $.post('http://tp_ranch_creator/delete_herding_point_index', JSON.stringify({ spawn_point_index: index }));
  });


  $(document).on("click", "[id^='herding-wolf-attacks-list-delete-']", function () {
    const index = this.id.replace("herding-wolf-attacks-list-delete-", "");
    PlayButtonClickSound();

    $.post('http://tp_ranch_creator/delete_herding_wolf_attack_point_index', JSON.stringify({ spawn_point_index: index }));
  });


  $("#main").on("click", ".animals-actions-list-button", function () {
    PlayButtonClickSound();

    const animal_count = $(this).data("animal-count");

    let $object = null;
    let $animal = null;

    switch (SELECTED_ANIMAL_ACTION_TYPE) {
      case 'SPAWN':
        $object = null;

        switch (SELECTED_ANIMAL_TYPE) {
          case 'COW':
            $animal = 'a_c_cow';
            break;

          case 'GOAT':
            $animal = 'a_c_goat_01';
            break;

          case 'SHEEP':
            $animal = 'a_c_sheep_01';
            break;

          case 'CHICKEN':
            $animal = 'a_c_chicken_01';
            break;

          case 'PIG':
            $animal = 'a_c_pig_01';
            break;

        }


        break;

      case 'MILKING':
        $object = null;
        break;

      case 'BUCKET':
        $object = 's_bucketmilk01x';
        break;

      case 'POOP':
        $object = 'p_sheeppoop01x';
        break;

      case 'SHEARING':
        $object = null;
        break;

      case 'EGG_SPAWN':
        $object = 's_gatoregg01x';
        break;

      case 'FEEDBAG':
        $object = 'p_mp_feedbaghang01x';
        break;

      case 'FEEDING':
        $object = null;
        break;

      case 'DELIVERY':
        $object = null;
        break;

    }

    if ($object != null || $animal != null) {
      $(".placement-info").fadeIn(); // requires placement info
    }

    $.post('http://tp_ranch_creator/startCoordsPlacement', JSON.stringify({
      action_index: SELECTED_ANIMAL_TYPE + '-' + SELECTED_ANIMAL_ACTION_TYPE + '-' + animal_count,
      input_class_index: ".animals-actions-list-input-" + animal_count,
      object: $object,
      animal: $animal,
      is_animal_section: true,

    }));

  });

  $(document).on("click", "[id^='animals-actions-list-delete-']", function () {
    const index = this.id.replace("animals-actions-list-delete-", "");
    PlayButtonClickSound();

    $.post('http://tp_ranch_creator/delete_spawned_egg_index', JSON.stringify({ egg_index: index }));
  });

  $(document).on("click", ".animals-cow-buttons-list-button", function () {
    PlayButtonClickSound();

    const actionIndex = $(this).data("button");
    $(".animals-cow").hide();

    let $count = $("#animals-cow-amount-input").val();

    SELECTED_ANIMAL_TYPE_SECTION = '.animals-cow';
    SELECTED_ANIMAL_TYPE = 'COW';
    SELECTED_ANIMAL_ACTION_TYPE = actionIndex;

    $("#main-config-data-button").show();

    $.post('http://tp_ranch_creator/request_selected_animal_type_actions_section', JSON.stringify({ section: 'COW', count: $count, action_index: actionIndex }));
  });

  $(document).on("click", ".animals-goat-buttons-list-button", function () {
    PlayButtonClickSound();

    const actionIndex = $(this).data("button");
    $(".animals-goat").hide();

    let $count = $("#animals-goat-amount-input").val();

    SELECTED_ANIMAL_TYPE_SECTION = '.animals-goat';
    SELECTED_ANIMAL_TYPE = 'GOAT';
    SELECTED_ANIMAL_ACTION_TYPE = actionIndex;

    $("#main-config-data-button").show();


    $.post('http://tp_ranch_creator/request_selected_animal_type_actions_section', JSON.stringify({ section: 'GOAT', count: $count, action_index: actionIndex }));
  });

  $(document).on("click", ".animals-sheep-buttons-list-button", function () {
    PlayButtonClickSound();

    const actionIndex = $(this).data("button");
    $(".animals-sheep").hide();

    let $count = $("#animals-sheep-amount-input").val();

    SELECTED_ANIMAL_TYPE_SECTION = '.animals-sheep';
    SELECTED_ANIMAL_TYPE = 'SHEEP';
    SELECTED_ANIMAL_ACTION_TYPE = actionIndex;

    $("#main-config-data-button").show();

    $.post('http://tp_ranch_creator/request_selected_animal_type_actions_section', JSON.stringify({ section: 'SHEEP', count: $count, action_index: actionIndex }));
  });

  $(document).on("click", ".animals-chicken-buttons-list-button", function () {
    PlayButtonClickSound();

    const actionIndex = $(this).data("button");
    $(".animals-chicken").hide();

    let $count = $("#animals-chicken-amount-input").val();

    SELECTED_ANIMAL_TYPE_SECTION = '.animals-chicken';
    SELECTED_ANIMAL_TYPE = 'CHICKEN';
    SELECTED_ANIMAL_ACTION_TYPE = actionIndex;

    $("#main-config-data-button").show();

    $.post('http://tp_ranch_creator/request_selected_animal_type_actions_section', JSON.stringify({ section: 'CHICKEN', count: $count, action_index: actionIndex }));
  });

  $(document).on("click", ".animals-pig-buttons-list-button", function () {
    PlayButtonClickSound();

    const actionIndex = $(this).data("button");
    $(".animals-pig").hide();

    let $count = $("#animals-pig-amount-input").val();

    SELECTED_ANIMAL_TYPE_SECTION = '.animals-pig';
    SELECTED_ANIMAL_TYPE = 'PIG';
    SELECTED_ANIMAL_ACTION_TYPE = actionIndex;

    $("#main-config-data-button").show();

    $.post('http://tp_ranch_creator/request_selected_animal_type_actions_section', JSON.stringify({ section: 'PIG', count: $count, action_index: actionIndex }));
  });

  $(document).on("click", ".herding-buttons-list-button", function () {
    PlayButtonClickSound();

    const actionIndex = $(this).data("button");
    $(".herding").fadeOut();
    $("#main-back-button").hide();
    $(".herding-wolf-attacks").hide();
    //$("#main-config-data-button").show();

    OPENED_SECTION_HERDING_INDEX_NAME = actionIndex;

    const inputs = [
      "#animals-sheep-amount-input",
      "#animals-cow-amount-input",
      "#animals-goat-amount-input",
    ];

    const highestCount = Math.max(
      ...inputs.map(selector => Number($(selector).val()))
    );

    switch (actionIndex) {
      case "SPAWN_POINTS":
        $("#herding-spawn-points-list").html("");
        $(".herding-spawn-points").fadeIn();
        OPENED_SECTION_HERDING_CLASS_NAME = ".herding-spawn-points";
        $("#main-config-data-button").hide();
        $.post('http://tp_ranch_creator/request_spawn_points_section', JSON.stringify({ highestCount: highestCount }));
        break;

      case "HERDING_POINTS":
        $("#herding-herding-list").html("");
        $(".herding-herding-points").fadeIn();
        OPENED_SECTION_HERDING_CLASS_NAME = ".herding-herding-points";
        $("#main-config-data-button").hide();

        $.post('http://tp_ranch_creator/request_herding_points_section', JSON.stringify({ highestCount: highestCount }));
        break;

      case "WOLF_ATTACKS":
        $("#herding-wolf-attacks-list").html("");
        $(".herding-wolf-attacks").fadeIn();
        OPENED_SECTION_HERDING_CLASS_NAME = ".herding-wolf-attacks";
        $("#main-config-data-button").hide();

        $.post('http://tp_ranch_creator/request_herding_wolf_attacks_points_section', JSON.stringify({ highestCount: highestCount }));
        break;
    }

  });

  $('#main').on("click", "#herding-spawn-points-back-button", function () {
    PlayButtonClickSound();

    $(".herding-spawn-points").fadeOut();
    $(".herding").fadeIn();
    $("#main-back-button").show();
    $("#main-config-data-button").show();
    $(".herding-wolf-attacks").hide();

    const inputs = [
      "#animals-sheep-amount-input",
      "#animals-cow-amount-input",
      "#animals-goat-amount-input",
    ];

    const highestCount = Math.max(
      ...inputs.map(selector => Number($(selector).val()))
    );

    $.post('http://tp_ranch_creator/request_herding_points_config_data', JSON.stringify({ count: false }));
    $.post('http://tp_ranch_creator/request_herding_spawn_points_config_data', JSON.stringify({ highestCount: highestCount, count: false }));
    $.post('http://tp_ranch_creator/request_herding_wolf_attacks_config_data', JSON.stringify({ count: false }));
  });


  $('#main').on("click", "#herding-herding-back-button", function () {
    PlayButtonClickSound();

    $(".herding-herding-points").fadeOut();
    $(".herding").fadeIn();
    $("#main-back-button").show();
    $("#main-config-data-button").show();
    $(".herding-wolf-attacks").hide();

    const inputs = [
      "#animals-sheep-amount-input",
      "#animals-cow-amount-input",
      "#animals-goat-amount-input",
    ];

    const highestCount = Math.max(
      ...inputs.map(selector => Number($(selector).val()))
    );

    $.post('http://tp_ranch_creator/request_herding_points_config_data', JSON.stringify({ count: false }));
    $.post('http://tp_ranch_creator/request_herding_spawn_points_config_data', JSON.stringify({ highestCount: highestCount, count: false }));
    $.post('http://tp_ranch_creator/request_herding_wolf_attacks_config_data', JSON.stringify({ count: false }));
  });

  $('#main').on("click", "#herding-wolf-attacks-back-button", function () {
    PlayButtonClickSound();

    $(".herding-wolf-attacks").fadeOut();
    $(".herding").fadeIn();
    $("#main-back-button").show();
    $("#main-config-data-button").show();
    const inputs = [
      "#animals-sheep-amount-input",
      "#animals-cow-amount-input",
      "#animals-goat-amount-input",
    ];

    const highestCount = Math.max(
      ...inputs.map(selector => Number($(selector).val()))
    );

    $.post('http://tp_ranch_creator/request_herding_points_config_data', JSON.stringify({ count: false }));
    $.post('http://tp_ranch_creator/request_herding_spawn_points_config_data', JSON.stringify({ highestCount: highestCount, count: false }));
    $.post('http://tp_ranch_creator/request_herding_wolf_attacks_config_data', JSON.stringify({ count: false }));
  });


  $(document).on("click", ".animals-buttons-list-button", function () {
    PlayButtonClickSound();

    const actionIndex = $(this).data("button");
    $("#animals-buttons-list").hide();
    $("#main-back-button").hide();
    $("#main-config-data-button").show();

    OPENED_SECTION_ANIMAL_INDEX_NAME = actionIndex;

    switch (actionIndex) {
      case "COW":
        $("#animals-cow-buttons-list").html("");
        $(".animals-cow").fadeIn();
        OPENED_SECTION_ANIMAL_CLASS_NAME = ".animals-cow";
        $.post('http://tp_ranch_creator/request_animal_section_buttons', JSON.stringify({ section: 'COW', list_class: "animals-cow-buttons-list" }));

        $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: 'COW' }));
        break;

      case "GOAT":
        $("#animals-goat-buttons-list").html("");
        $(".animals-goat").fadeIn();
        OPENED_SECTION_ANIMAL_CLASS_NAME = ".animals-goat";
        $.post('http://tp_ranch_creator/request_animal_section_buttons', JSON.stringify({ section: 'GOAT', list_class: "animals-goat-buttons-list" }));
        $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: 'GOAT' }));
        break;

      case "SHEEP":
        $("#animals-sheep-buttons-list").html("");
        $(".animals-sheep").fadeIn();
        OPENED_SECTION_ANIMAL_CLASS_NAME = ".animals-sheep";
        $.post('http://tp_ranch_creator/request_animal_section_buttons', JSON.stringify({ section: 'SHEEP', list_class: "animals-sheep-buttons-list" }));
        $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: 'SHEEP' }));
        break;

      case "CHICKEN":
        $("#animals-chicken-buttons-list").html("");
        $(".animals-chicken").fadeIn();
        OPENED_SECTION_ANIMAL_CLASS_NAME = ".animals-chicken";
        $.post('http://tp_ranch_creator/request_animal_section_buttons', JSON.stringify({ section: 'CHICKEN', list_class: "animals-chicken-buttons-list" }));
        $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: 'CHICKEN' }));
        break;

      case "PIG":
        $("#animals-pig-buttons-list").html("");
        $(".animals-pig").fadeIn();
        OPENED_SECTION_ANIMAL_CLASS_NAME = ".animals-pig";
        $.post('http://tp_ranch_creator/request_animal_section_buttons', JSON.stringify({ section: 'PIG', list_class: "animals-pig-buttons-list" }));
        $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: 'PIG' }));
        break;

    }

  });

  $("#main").on("click", "#animals-actions-create-button", function () {
    PlayButtonClickSound();

    $(".placement-info").fadeIn(); // requires placement info

    $.post('http://tp_ranch_creator/startEggPlacement', JSON.stringify({
      egg_index: null,

    }));

  });

  $("#main").on("click", "#animals-actions-back-button", function () {
    PlayButtonClickSound();
    $("#main-config-data-button").show();
    $("#animals-actions-create-button").hide();
    $('.animals-actions').hide();
    $(SELECTED_ANIMAL_TYPE_SECTION).fadeIn();
    $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: SELECTED_ANIMAL_TYPE }));

  });

  $("#main").on("click", "#animals-cow-back-button", function () {
    PlayButtonClickSound();


    $("#main-config-data-button").hide();
    $(OPENED_SECTION_ANIMAL_CLASS_NAME).fadeOut();
    $("#main-back-button").show();
    $("#animals-buttons-list").fadeIn();
  });

  $("#main").on("click", "#animals-goat-back-button", function () {
    PlayButtonClickSound();

    $("#main-config-data-button").hide();
    $(OPENED_SECTION_ANIMAL_CLASS_NAME).fadeOut();
    $("#main-back-button").show();
    $("#animals-buttons-list").fadeIn();
  });

  $("#main").on("click", "#animals-chicken-back-button", function () {
    PlayButtonClickSound();

    $("#main-config-data-button").hide();
    $(OPENED_SECTION_ANIMAL_CLASS_NAME).fadeOut();
    $("#main-back-button").show();
    $("#animals-buttons-list").fadeIn();
  });

  $("#main").on("click", "#animals-sheep-back-button", function () {
    PlayButtonClickSound();

    $("#main-config-data-button").hide();
    $(OPENED_SECTION_ANIMAL_CLASS_NAME).fadeOut();
    $("#main-back-button").show();
    $("#animals-buttons-list").fadeIn();
  });

  $("#main").on("click", "#animals-pig-back-button", function () {
    PlayButtonClickSound();

    $("#main-config-data-button").hide();
    $(OPENED_SECTION_ANIMAL_CLASS_NAME).fadeOut();
    $("#main-back-button").show();
    $("#animals-buttons-list").fadeIn();
  });


  $(document).on("click", ".main-buttons-list-button", function () {
    PlayButtonClickSound();

    const actionIndex = $(this).data("button");

    $("#main-all-config-data-button").fadeOut();
    $("#main-exit-button").hide();
    $("#main-back-button").show();
    $("#main-config-data-button").show();
    $("#main-buttons-list").hide();
    $(".animals").hide();

    OPENED_SECTION_INDEX_NAME = actionIndex;

    switch (actionIndex) {
      case "COST":

        $(".main-cost").fadeIn();
        OPENED_SECTION_INDEX_CLASS_NAME = ".main-cost";
        break;

      case "REQUIRED_JOBS":
        $(".main-required-jobs").fadeIn();
        OPENED_SECTION_INDEX_CLASS_NAME = ".main-required-jobs";
        break;

      case "MAIN_COORDS":
        $(".main-coords").fadeIn();
        OPENED_SECTION_INDEX_CLASS_NAME = ".main-coords";
        break;

      case "ANIMAL_STORE":
        $(".animal-store").fadeIn();
        OPENED_SECTION_INDEX_CLASS_NAME = ".animal-store";
        break;

      case "MILK_CONTAINER":
        $(".milk-container").fadeIn();
        OPENED_SECTION_INDEX_CLASS_NAME = ".milk-container";
        break;

      case "WATER_BARREL":
        $(".water-barrel").fadeIn();
        OPENED_SECTION_INDEX_CLASS_NAME = ".water-barrel";
        break;

      case "HAY_BARREL":
        $(".hay-barrel").fadeIn();
        OPENED_SECTION_INDEX_CLASS_NAME = ".hay-barrel";
        break;

      case "PITCH_FORK":
        $(".pitch-fork").fadeIn();
        OPENED_SECTION_INDEX_CLASS_NAME = ".pitch-fork";
        break;

      case "CAULDRON":
        $(".cauldron").fadeIn();
        OPENED_SECTION_INDEX_CLASS_NAME = ".cauldron";
        break;

      case "ANIMALS":
        $("#animals-buttons-list").html("");

        //$("#main-config-data-button").hide();
        $("#main-all-config-data-button").hide();
        $("#main-config-data-button").hide();
        $("#main-back-button").show();

        $.post('http://tp_ranch_creator/request_animals_section_buttons', JSON.stringify({}));

        $(".animals-cow").hide();
        $(".animals-sheep").hide();
        $(".animals-goat").hide();
        $(".animals-chicken").hide();
        $(".animals-pig").hide();

        $(".animals").fadeIn();
        break;

      case "HERDING":
        $("#herding-buttons-list").html("");
        OPENED_SECTION_INDEX_CLASS_NAME = ".herding";
        $.post('http://tp_ranch_creator/request_herding_section_buttons', JSON.stringify({}));

        $(".herding").fadeIn();

        const inputs = [
          "#animals-sheep-amount-input",
          "#animals-cow-amount-input",
          "#animals-goat-amount-input",
        ];

        const highestCount = Math.max(
          ...inputs.map(selector => Number($(selector).val()))
        );

        $.post('http://tp_ranch_creator/request_herding_points_config_data', JSON.stringify({ count: false }));
        $.post('http://tp_ranch_creator/request_herding_spawn_points_config_data', JSON.stringify({ highestCount: highestCount, count: false }));
        $.post('http://tp_ranch_creator/request_herding_wolf_attacks_config_data', JSON.stringify({ count: false }));
    }
  });


  $("#main").on("click", "#main-exit-button", function () {
    PlayButtonClickSound();
    $(".exit-dialog").fadeIn();
  });

  $("#main").on("click", "#main-back-button", function () {
    PlayButtonClickSound();

    $(OPENED_SECTION_INDEX_CLASS_NAME).fadeOut();
    $("#main-back-button").hide();
    $("#main-config-data-button").fadeOut();
    $("#main-all-config-data-button").show();
    $("#main-exit-button").show();
    $(".animals").hide();

    $.post('http://tp_ranch_creator/request_buttons', JSON.stringify({}));

    $("#main-buttons-list").fadeIn();

  });

  $("#main").on("click", "#exit-dialog-accept-button", function () {
    PlayButtonClickSound();
    CloseNUI();
  });

  $("#main").on("click", "#exit-dialog-cancel-button", function () {
    PlayButtonClickSound();
    $(".exit-dialog").fadeOut();
  });


  $(".config-data-dialog").on("click", "#config-data-close-button", function () {
    PlayButtonClickSound();
    $(".config-data-dialog").fadeOut();
  });

  $(".config-data-dialog").on("click", "#config-data-copy-button", function () {
    PlayButtonClickSound();

    const d = document.getElementById("config-data-message");

    const range = document.createRange();
    range.selectNode(d);

    const selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);

    document.execCommand("copy");

  });

  const animalSelector = `
  .animal-store-cow-switch,
  .animal-store-sheep-switch,
  .animal-store-chicken-switch,
  .animal-store-pig-switch,
  .animal-store-goat-switch
`;

  $("#main").on("mouseenter", animalSelector, function () {
    let enabled = $(this).find("input[type=checkbox]").is(":checked");

    if (!enabled) {
      $(".tooltip")
        .text("If you enable the switch, the specified animal will be able to be used in the ranch and also purchased on the store.")
        .show();
    } else {
      $(".tooltip")
        .text("If you disable the switch, the specified animal will no longer be able to be purchased on the store.")
        .show();
    }
  });

  $("#main").on("mousemove", animalSelector, function (e) {
    $(".tooltip").css({
      left: e.clientX + 15,
      top: e.clientY + 15
    });
  });

  $("#main").on("mouseleave", animalSelector, function () {
    $(".tooltip").hide();
  });


  // Main Coords
  $("#main").on("click", "#main-coords-position-button", function () {
    PlayButtonClickSound();


    $.post('http://tp_ranch_creator/startCoordsPlacement', JSON.stringify({
      action_index: OPENED_SECTION_INDEX_NAME,
      input_class_index: "#main-coords-position-input",

    }));

  });

  // Milk Jug

  $("#main").on("click", "#milk-container-position-button", function () {
    PlayButtonClickSound();

    $(".placement-info").fadeIn(); // requires placement info

    $.post('http://tp_ranch_creator/startCoordsPlacement', JSON.stringify({
      action_index: OPENED_SECTION_INDEX_NAME + "_1",
      input_class_index: "#milk-container-position-input",
      object: 'p_milkcan01x',

    }));

  });

  $("#main").on("click", "#milk-container-deliver-button", function () {
    PlayButtonClickSound();

    $.post('http://tp_ranch_creator/startCoordsPlacement', JSON.stringify({
      action_index: OPENED_SECTION_INDEX_NAME + "_2",
      input_class_index: "#milk-container-deliver-input",

    }));

  });

  // Water barrel


  $("#main").on("click", "#water-barrel-position-button", function () {
    PlayButtonClickSound();

    $(".placement-info").fadeIn(); // requires placement info

    $.post('http://tp_ranch_creator/startCoordsPlacement', JSON.stringify({
      action_index: OPENED_SECTION_INDEX_NAME,
      input_class_index: "#water-barrel-position-input",
      object: 'p_barrelhalf02x',

    }));

  });

  // Hay 

  $("#main").on("click", "#hay-barrel-position-button", function () {
    PlayButtonClickSound();

    $.post('http://tp_ranch_creator/startCoordsPlacement', JSON.stringify({
      action_index: OPENED_SECTION_INDEX_NAME,
      input_class_index: "#hay-barrel-position-input",

    }));

  });

  // pitchfork

  $("#main").on("click", "#pitch-fork-position-button", function () {
    PlayButtonClickSound();

    $(".placement-info").fadeIn(); // requires placement info

    $.post('http://tp_ranch_creator/startCoordsPlacement', JSON.stringify({
      action_index: OPENED_SECTION_INDEX_NAME,
      input_class_index: "#pitch-fork-position-input",
      object: 'p_pitchfork01x',

    }));

  });

  // cauldron

  $("#main").on("click", "#cauldron-position-button", function () {
    PlayButtonClickSound();

    $(".placement-info").fadeIn(); // requires placement info

    $.post('http://tp_ranch_creator/startCoordsPlacement', JSON.stringify({
      action_index: OPENED_SECTION_INDEX_NAME + "_1",
      input_class_index: "#cauldron-position-input",
      object: 'p_cauldron01x',

    }));

  });

  $("#main").on("click", "#cauldron-teleport-button", function () {
    PlayButtonClickSound();

    $.post('http://tp_ranch_creator/startCoordsPlacement', JSON.stringify({
      action_index: OPENED_SECTION_INDEX_NAME + "_2",
      input_class_index: "#cauldron-teleport-input",

    }));

  });


  $("#main").on("click", "#main-config-data-button", function () {
    PlayButtonClickSound();

    RETRIEVED_CLASS_CONFIG_DATA = "";

    const coordRegex = /^\{\s*x\s*=\s*-?\d+(\.\d+)?\s*,\s*y\s*=\s*-?\d+(\.\d+)?\s*,\s*z\s*=\s*-?\d+(\.\d+)?\s*\}$/;

    switch (OPENED_SECTION_INDEX_NAME) {
      case "COST":

        const cost = {
          IsItem: $('input[name="payment-item-method"]:checked').val() == 1 ? false : true,
          Account: $("#main-cost-method-input").val().trim() || "CASH",
          Amount: Number($("#main-cost-input").val()) || 0
        };

        RETRIEVED_CLASS_CONFIG_DATA = `Cost = { IsItem = ${cost.IsItem}, Account = "${cost.Account}", Amount = ${cost.Amount} },`;
        break;

      case "REQUIRED_JOBS":

        const input = $("#main-required-jobs-input").val().trim();

        let jobsText;

        if (input.toLowerCase() === "false" || input === "") {
          jobsText = "false";
        } else if (input.toLowerCase() === "true") {
          jobsText = "false";
        } else {
          jobsText = input
            // Split by commas OR spaces
            .split(/[,\s]+/)
            .filter(job => job.length > 0)
            // Wrap each job in quotes
            .map(job => `"${job}"`)
            // Join with commas
            .join(", ");
        }

        RETRIEVED_CLASS_CONFIG_DATA = `
-- Set to false if you want everyone to be able to be added as a member on this ranch,
-- otherwise, add the desired jobs to join when having only the required job(s).
-- For adding a job(s), it requires a table form such as: { "job1", "job2" }
AddMemberRequiredJobs = ${(jobsText === false || jobsText === "false") ? "false" : `{ ${jobsText} }`},

AddMemberRequiredJobsNotify = {
  text = 'You cannot add as a member the specified user, this player does not have the required job.',
  duration = 6
},
        `;

        break;

      case "MAIN_COORDS":
        const main_coords = $("#main-coords-position-input").val().trim();
        let coordsValue = main_coords;

        // check if it contains vector3(...)
        const isVector3 =
          /^vector3\s*\(\s*-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?\s*\)$/i.test(main_coords);

        if (!isVector3) {
          coordsValue = "vector3(0, 0, 0)";
        }

        RETRIEVED_CLASS_CONFIG_DATA = `Coords = ${coordsValue},`;
        break;

      case "ANIMAL_STORE":
        const animals = [];

        const animalConfig = [
          { id: "animal-store-chicken-switch", name: "a_c_chicken_01" },
          { id: "animal-store-sheep-switch", name: "a_c_sheep_01" },
          { id: "animal-store-cow-switch", name: "a_c_cow" },
          { id: "animal-store-goat-switch", name: "a_c_goat_01" },
          { id: "animal-store-pig-switch", name: "a_c_pig_01" }
        ];

        animalConfig.forEach(animal => {
          const isChecked = document.getElementById(animal.id).checked;

          if (isChecked) {
            animals.push(`'${animal.name}',`);
          }
        });

        // 8 spaces on join
        RETRIEVED_CLASS_CONFIG_DATA = `
AnimalStore = {
    -- Below, you add the supported animals to be bought from the store.
    -- If the ranch does not support a specific animal (any of the added ones), remove it.
    Animals = {
        ${animals.join("\n        ")} 
    },
},
`;
        break;

      case "MILK_CONTAINER":

        let jug1 = $("#milk-container-position-input").val().trim();
        let jug2 = $("#milk-container-deliver-input").val().trim();

        const access_milk_jug_coords = parseXYZWithPRY(jug1);
        const access_milk_jug_deliver_coords = parseXYZWithDistance(jug2);

        RETRIEVED_CLASS_CONFIG_DATA = `
-- The coords to open the milk container storage, including the placement of the object itself.
-- The render_distance is for the distance to spawn the object between player and position.
MilkContainerCoords = ${access_milk_jug_coords},

-- The coords to deliver the collected product (milk jug) from the cows or goats.
-- (!) heading is required! is not added by mistake.
DeliverProductCoords = ${access_milk_jug_deliver_coords},
        `;

        break;

      case "WATER_BARREL":

        let waterbarrelinput = $("#water-barrel-position-input").val().trim();
        const waterBarrelCoords = parseXYZWithPRY(waterbarrelinput);

        RETRIEVED_CLASS_CONFIG_DATA = `
-- The coords to add water for the animals, including the placement of the object itself.
-- The render_distance is for the distance to spawn the object between player and position.
WaterBarrelCoords = ${waterBarrelCoords},
WaterBarrelDistance = 1.45,
        `;
        break;

      case "HAY_BARREL":

        let hayinput = $("#hay-barrel-position-input").val().trim();

        const displayIcon = $('input[name="hay-diplay-item-method"]:checked').val() == "1";

        hayinput = hayinput.replace(
          /\}$/,
          `, display_icon = ${displayIcon}, display_icon_distance = 2.0, adjust_icon_height = 0.5, action_distance = 0.9 }`
        );

        RETRIEVED_CLASS_CONFIG_DATA = `
-- The coords to add food for the cows and goats.
-- Set display_icon to true to display an icon on the hay position when delivering hay (if item system is disabled)
HayFoodCoords = ${hayinput},
      `;
        break;

      case "PITCH_FORK":

        let pitchforkinput = $("#pitch-fork-position-input").val().trim();
        const pitchforkCoords = parseXYZWithPRY2(pitchforkinput);

        RETRIEVED_CLASS_CONFIG_DATA = `
-- The pitchfork object placement which is required to pickup poop from cows, goats or sheep to make a fertilizer.
-- p_pitchfork01x
PitchForkObjectCoords = ${pitchforkCoords},
RenderPitchForkDistance = 20.0,
`;
        break;

      case "CAULDRON":

        let cauldron1 = $("#cauldron-position-input").val().trim();
        let cauldron2 = $("#cauldron-teleport-input").val().trim();

        const cauldron1Coords =
          parseXYZWithPRY2(cauldron1).replace(
            "{",
            '{ object = "p_cauldron01x", '
          );

        const cauldron2Coords = parseXYZWithHeading(cauldron2);

        RETRIEVED_CLASS_CONFIG_DATA = `
-- The placement of the cauldron, the cauldron object placement is required to deliver the picked up poop from the pitchfork to make a fertilizer.
CauldronObject = ${cauldron1Coords},

--Set the desired coords through a game action(s) for the player to be teleported in the correct position for performing animation on the cauldron object.
TeleportPlayerOnCauldron = ${cauldron2Coords},
`;
        break;

      case "ANIMALS":

        const chicken = document.querySelector('.animals-chicken');
        const cow = document.querySelector('.animals-cow');
        const goat = document.querySelector('.animals-goat');
        const pig = document.querySelector('.animals-pig');
        const sheep = document.querySelector('.animals-sheep');

        const actions = document.querySelector('.animals-actions');

        const isChickenClassActive = chicken && chicken.offsetParent !== null;
        const isCowClassActive = cow && cow.offsetParent !== null;
        const isGoatClassActive = goat && goat.offsetParent !== null;
        const isPigClassActive = pig && pig.offsetParent !== null;
        const isSheepClassActive = sheep && sheep.offsetParent !== null;
        const isActionsClassActive = actions && actions.offsetParent !== null;

        if (isActionsClassActive) {

        } else {

          /* CHICKEN SECTION */
          if (isChickenClassActive) {

            const spawnCoords = ANIMAL_LATEST_CONFIG_DATA.CHICKEN?.SPAWN ?? DEFAULT_ANIMAL_CONFIG_DATA.CHICKEN?.SPAWN;
            const eggSpawnCoords = ANIMAL_LATEST_CONFIG_DATA.CHICKEN?.EGG_SPAWN ?? DEFAULT_ANIMAL_CONFIG_DATA.CHICKEN?.EGG_SPAWN;
            const feedbagStandCoords = ANIMAL_LATEST_CONFIG_DATA.CHICKEN?.FEEDBAG ?? DEFAULT_ANIMAL_CONFIG_DATA.CHICKEN?.FEEDBAG;
            const feedingCoords = ANIMAL_LATEST_CONFIG_DATA.CHICKEN?.FEEDING ?? DEFAULT_ANIMAL_CONFIG_DATA.CHICKEN?.FEEDING;
            const deliverFoodCoords = ANIMAL_LATEST_CONFIG_DATA.CHICKEN?.DELIVERY ?? DEFAULT_ANIMAL_CONFIG_DATA.CHICKEN?.DELIVERY;

            RETRIEVED_CLASS_CONFIG_DATA = GetChickenConfigData(
              spawnCoords,
              eggSpawnCoords,
              feedbagStandCoords,
              feedingCoords,
              deliverFoodCoords
            );

          } else if (isPigClassActive) {

            const spawnCoords = ANIMAL_LATEST_CONFIG_DATA.PIG?.SPAWN ?? DEFAULT_ANIMAL_CONFIG_DATA.PIG?.SPAWN;

            RETRIEVED_CLASS_CONFIG_DATA = GetPigConfigData(spawnCoords);

          } else if (isCowClassActive) {

            const spawnCoords = ANIMAL_LATEST_CONFIG_DATA.COW?.SPAWN ?? DEFAULT_ANIMAL_CONFIG_DATA.COW?.SPAWN;
            const milkingCoords = ANIMAL_LATEST_CONFIG_DATA.COW?.MILKING ?? DEFAULT_ANIMAL_CONFIG_DATA.COW?.MILKING;
            const bucketCoords = ANIMAL_LATEST_CONFIG_DATA.COW?.BUCKET ?? DEFAULT_ANIMAL_CONFIG_DATA.COW?.BUCKET;
            const poopCoords = ANIMAL_LATEST_CONFIG_DATA.COW?.POOP ?? DEFAULT_ANIMAL_CONFIG_DATA.COW?.POOP;

            RETRIEVED_CLASS_CONFIG_DATA = GetCowConfigData(
              spawnCoords,
              milkingCoords,
              bucketCoords,
              poopCoords
            );

          } else if (isGoatClassActive) {

            const spawnCoords = ANIMAL_LATEST_CONFIG_DATA.GOAT?.SPAWN ?? DEFAULT_ANIMAL_CONFIG_DATA.GOAT?.SPAWN;
            const milkingCoords = ANIMAL_LATEST_CONFIG_DATA.GOAT?.MILKING ?? DEFAULT_ANIMAL_CONFIG_DATA.GOAT?.MILKING;
            const bucketCoords = ANIMAL_LATEST_CONFIG_DATA.GOAT?.BUCKET ?? DEFAULT_ANIMAL_CONFIG_DATA.GOAT?.BUCKET;
            const poopCoords = ANIMAL_LATEST_CONFIG_DATA.GOAT?.POOP ?? DEFAULT_ANIMAL_CONFIG_DATA.GOAT?.POOP;

            RETRIEVED_CLASS_CONFIG_DATA = GetGoatConfigData(
              spawnCoords,
              milkingCoords,
              bucketCoords,
              poopCoords
            );

          } else if (isSheepClassActive) {

            const spawnCoords = ANIMAL_LATEST_CONFIG_DATA.SHEEP?.SPAWN ?? DEFAULT_ANIMAL_CONFIG_DATA.SHEEP?.SPAWN;
            const poopCoords = ANIMAL_LATEST_CONFIG_DATA.SHEEP?.POOP ?? DEFAULT_ANIMAL_CONFIG_DATA.SHEEP?.POOP;
            const shearingCoords = ANIMAL_LATEST_CONFIG_DATA.SHEEP?.SHEARING ?? DEFAULT_ANIMAL_CONFIG_DATA.SHEEP?.SHEARING;

            RETRIEVED_CLASS_CONFIG_DATA = GetSheepConfigData(
              spawnCoords,
              poopCoords,
              shearingCoords
            );

          }

        }

        break;

      case "HERDING":

        const spawnpoints = document.querySelector('.herding-spawn-points');
        const herdingpoints = document.querySelector('.herding-herding-points');

        const isHerdingSpawnPointsClassActive = spawnpoints && spawnpoints.offsetParent !== null;
        const isHerdingPointsClassActive = herdingpoints && herdingpoints.offsetParent !== null;

        let wolfEnabled = $('input[name="herding-wolf-attacks-item-method"]:checked').val() == 1 ? false : true;
        let wolfAttackChance = $("#herding-wolf-attacks-chance-input").val();
        let defaultWolfSpawnPoint =
          HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA?.[1] == null
            ? "{ x = 0, y = 0, z = 0, h = 0 }"
            : `{ x = ${HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA[1].x}, y = ${HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA[1].y}, z = ${HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA[1].z}, h = ${HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA[1].h} }`;

        if (isHerdingPointsClassActive) {
          RETRIEVED_CLASS_CONFIG_DATA = `

    -- Herding points for the cows, goats or sheep to go - once reached the last point, they will be teleported back into the ranch (their position)
    -- (!) Herding Points are also the maximum animals that go out for herding.
    HerdingPoints = {

        RGBA = {r = 255, g = 255, b = 255, a = 55},

${FormatLua(HERDING_LATEST_HERDING_POINTS_CONFIG_DATA, "        ", true)}
    },

    `;
        } else if (isHerdingSpawnPointsClassActive) {


        } else {
          RETRIEVED_CLASS_CONFIG_DATA = `

Herding = {
    -- The spawn points of the maximum cows, goats or sheep to take out.
    -- (!) Insert the maximum animals count you are having in the spawn points - the higher count (except chicken), which means if you have 2 cows and 4 goats, you need (4) herding spawn points in total.
    SpawnPoints = {
${FormatLua(HERDING_LATEST_SPAWN_POINTS_CONFIG_DATA, "        ", true)}
    },
          
    -- Should the herding be cancelled once the player goes too far while herding?
    CancelHerdingOncePlayerGoesFarDistance = { Enabled = true, Distance = 300.0 }, -- thats too far by default, you can leave it as it is if your herding points are not that far from ranch.

    -- The distance between the cow, goat or sheep and the point for moving to the next point.
    NearHerdingPointDistance = 3.0,

    -- The distance between the player and the herding point for displaying the icon.
    IconRenderingDistance = 25.0,

    -- The distance between the player and the herding point for displaying the marker.
    MarkerRenderingDistance = 25.0,

    -- Herding points for the cows, goats or sheep to go - once reached the last point, they will be teleported back into the ranch (their position)
    -- (!) Herding Points are also the maximum animals that go out for herding.
    HerdingPoints = {

        RGBA = {r = 255, g = 255, b = 255, a = 55},

${FormatLua(HERDING_LATEST_HERDING_POINTS_CONFIG_DATA, "        ", true)}
    },

    WolfAttack = {
        Enabled = ${wolfEnabled},

        -- Once herding starts, the system checks for a wolf attack. What should be the chance to have a wolf attack?
        -- Set to 0 to never have any wolf attacks (this is for all ranches).
        Chance = ${wolfAttackChance}, -- 0 of 100 %  

        -- Once herding started, what should be the distance for wolves to attack when a player is near to the @Coords ?
        AttackNearPlayerPosition = { 
            Coords = ${defaultWolfSpawnPoint}, -- default position is #1 Wolf spawnpoint
            Distance = 70.0,
        },

        -- The SpawnPoints are the spawned wolves and their locations
        -- (!) Permitted Models { a_c_wolf, a_c_wolf_medium, a_c_wolf_small, mp_a_c_wolf_01 }
        SpawnPoints = {

${HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA == null ? "" : FormatLua(HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA, "            ", true)}
        },

    },
},
    `;

        }

        break;
    }

    const el = document.getElementById("config-data-message");

    function escapeHtml(str) {
      return str
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");
    }

    function highlightLua(code) {
      code = escapeHtml(code);

      const spans = [];

      function protect(regex, wrapClass) {
        code = code.replace(regex, (match) => {
          // Removed the accidental space in the token
          const token = `__TOKEN_${spans.length}__`;

          // Fixed HTML spacing
          spans.push(`<span class="${wrapClass}">${match}</span>`);

          return token;
        });
      }

      // 1. comments
      protect(/--.*$/gm, "lua-comment");

      // 2. strings
      protect(/(['"])(.*?)\1/g, "lua-string");

      // 3. booleans
      protect(/\b(true|false)\b/g, "lua-bool");

      // 4. numbers
      protect(/\b\d+(\.\d+)?\b/g, "lua-number");

      // 5. brackets
      protect(/[\{\}\(\)\[\]]/g, "lua-bracket");

      // 6. commas
      protect(/,/g, "lua-comma");

      // Restore tokens
      code = code.replace(/__TOKEN_(\d+)__/g, (_, i) => spans[Number(i)]);

      return `<span class="lua-base">${code}</span>`;
    }

    const formatted = highlightLua(RETRIEVED_CLASS_CONFIG_DATA);

    el.innerHTML = formatted;

    $(".config-data-dialog").fadeIn();

  });

  $("#main").on("click", "#main-all-config-data-button", async function () {
    PlayButtonClickSound();

    $.post('http://tp_ranch_creator/request_config_data', JSON.stringify({})); // MUST BE #1ST

    // We request latest data.
    $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: 'COW' }));
    $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: 'GOAT' }));
    $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: 'SHEEP' }));
    $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: 'CHICKEN' }));
    $.post('http://tp_ranch_creator/request_selected_animal_config_data', JSON.stringify({ section: 'PIG' }));

    const inputs = [
      "#animals-sheep-amount-input",
      "#animals-cow-amount-input",
      "#animals-goat-amount-input",
    ];

    const highestCount = Math.max(
      ...inputs.map(selector => Number($(selector).val()))
    );

    $.post('http://tp_ranch_creator/request_herding_points_config_data', JSON.stringify({ count: true }));
    $.post('http://tp_ranch_creator/request_herding_spawn_points_config_data', JSON.stringify({ highestCount: highestCount, count: true }));
    $.post('http://tp_ranch_creator/request_herding_wolf_attacks_config_data', JSON.stringify({ count: true }));
  });


  function OpenConfigData() {

    let cauldron1 = $("#cauldron-position-input").val().trim();
    let cauldron2 = $("#cauldron-teleport-input").val().trim();

    const cauldron1Coords =
      parseXYZWithPRY2(cauldron1).replace(
        "{",
        '{ object = "p_cauldron01x", '
      );

    const cauldron2Coords = parseXYZWithHeading(cauldron2);

    let pitchforkinput = $("#pitch-fork-position-input").val().trim();
    const pitchforkCoords = parseXYZWithPRY2(pitchforkinput);

    let hayinput = $("#hay-barrel-position-input").val().trim();

    const displayIcon = $('input[name="hay-diplay-item-method"]:checked').val() == "1";

    hayinput = hayinput.replace(
      /\}$/,
      `, display_icon = ${displayIcon}, display_icon_distance = 2.0, adjust_icon_height = 0.5, action_distance = 0.9 }`
    );


    const animals = [];

    const animalConfig = [
      { id: "animal-store-chicken-switch", name: "a_c_chicken_01" },
      { id: "animal-store-sheep-switch", name: "a_c_sheep_01" },
      { id: "animal-store-cow-switch", name: "a_c_cow" },
      { id: "animal-store-goat-switch", name: "a_c_goat_01" },
      { id: "animal-store-pig-switch", name: "a_c_pig_01" }
    ];

    animalConfig.forEach(animal => {
      const isChecked = document.getElementById(animal.id).checked;

      if (isChecked) {
        animals.push(`'${animal.name}',`);
      }
    });

    const input = $("#main-required-jobs-input").val().trim();

    let jobsText;

    if (input.toLowerCase() === "false" || input === "") {
      jobsText = "false";
    } else if (input.toLowerCase() === "true") {
      jobsText = "false";
    } else {
      jobsText = input
        // Split by commas OR spaces
        .split(/[,\s]+/)
        .filter(job => job.length > 0)
        // Wrap each job in quotes
        .map(job => `"${job}"`)
        // Join with commas
        .join(", ");
    }

    const cost = {
      IsItem: $('input[name="payment-item-method"]:checked').val() == 1 ? false : true,
      Account: $("#main-cost-method-input").val().trim() || "CASH",
      Amount: Number($("#main-cost-input").val()) || 0
    };

    let waterbarrelinput = $("#water-barrel-position-input").val().trim();
    const waterBarrelCoords = parseXYZWithPRY(waterbarrelinput);


    let jug1 = $("#milk-container-position-input").val().trim();
    let jug2 = $("#milk-container-deliver-input").val().trim();

    const access_milk_jug_coords = parseXYZWithPRY(jug1);
    const access_milk_jug_deliver_coords = parseXYZWithDistance(jug2);

    const main_coords = $("#main-coords-position-input").val().trim();
    let coordsValue = main_coords;

    // check if it contains vector3(...)
    const isVector3 =
      /^vector3\s*\(\s*-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?\s*\)$/i.test(main_coords);

    if (!isVector3) {
      coordsValue = "vector3(0, 0, 0)";
    }

    let wolfEnabled = $('input[name="herding-wolf-attacks-item-method"]:checked').val() == 1 ? false : true;
    let wolfAttackChance = $("#herding-wolf-attacks-chance-input").val();
    let defaultWolfSpawnPoint =
      HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA?.[1] == null
        ? "{ x = 0, y = 0, z = 0, h = 0 }"
        : `{ x = ${HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA[1].x}, y = ${HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA[1].y}, z = ${HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA[1].z}, h = ${HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA[1].h} }`;

    let ranchConfig = `
Coords = ${coordsValue},

ActionDistance = 1.1,

ActionMarkers = {
    Enabled = true,

    Distance = 5.0,
    RGBA = {r = 255, g = 255, b = 255, a = 55},
},

-- The coords to open the milk container storage, including the placement of the object itself.
-- The render_distance is for the distance to spawn the object between player and position.
MilkContainerCoords = ${access_milk_jug_coords},

-- The coords to deliver the collected product (milk jug) from the cows or goats.
-- (!) heading is required! is not added by mistake.
DeliverProductCoords = ${access_milk_jug_deliver_coords},

-- The action distance to access the milk container storage.
OpenMilkContainerDistance = 1.2,

-- How much milk should the jug container can hold in total?
MaximumRanchMilkJugContainerCapacity = 100,

-- The coords to add water for the animals, including the placement of the object itself.
-- The render_distance is for the distance to spawn the object between player and position.
WaterBarrelCoords = ${waterBarrelCoords},
WaterBarrelDistance = 1.45,

Cost = { IsItem = ${cost.IsItem}, Account = "${cost.Account}", Amount = ${cost.Amount} },

GiveRequiredJobMoney = {
    IsItem = false,
    Account = "CASH",
    Amount = 15,
    Notify = "The target player has successfully bought the ranch and you have received 15 dollars.",
    NotifyDuration = 10
},

AddMemberRequiredJobs = ${(jobsText === false || jobsText === "false") ? "false" : `{ ${jobsText} }`},

AddMemberRequiredJobsNotify = {
    text = 'You cannot add as a member the specified user, this player does not have the required job.',
    duration = 6
},

AnimalStore = {
    Animals = {
        ${animals.join("\n        ")}
    },
},

--The coords to add food for the cows and goats.
HayFoodCoords = ${hayinput},

-- The pitchfork object placement.
PitchForkObjectCoords = ${pitchforkCoords},
RenderPitchForkDistance = 20.0,

CauldronObject = ${cauldron1Coords},

TeleportPlayerOnCauldron = ${cauldron2Coords},

GiveFertilizerDisplay = "Press ~o~G~q~ to start making ~t3~manure fertilizer~q~.",
FertilizerProgressBar = {
    Duration = 10,
    Text = 'Making fertilizer..'
},

GiveFertilizerItem = {
    Item = 'fertilizer_manure',
    Label = 'Manure Fertilizer',
    Quantity = 5
},
`;

    ranchConfig += GetAllAnimalConfigData();


    ranchConfig += `

Herding = {
    -- The spawn points of the maximum cows, goats or sheep to take out.
    -- (!) Insert the maximum animals count you are having in the spawn points - the higher count (except chicken), which means if you have 2 cows and 4 goats, you need (4) herding spawn points in total.
    SpawnPoints = {
${FormatLua(HERDING_LATEST_SPAWN_POINTS_CONFIG_DATA, "        ", true)}
    },
          
    -- Should the herding be cancelled once the player goes too far while herding?
    CancelHerdingOncePlayerGoesFarDistance = { Enabled = true, Distance = 300.0 }, -- thats too far by default, you can leave it as it is if your herding points are not that far from ranch.

    -- The distance between the cow, goat or sheep and the point for moving to the next point.
    NearHerdingPointDistance = 3.0,

    -- The distance between the player and the herding point for displaying the icon.
    IconRenderingDistance = 25.0,

    -- The distance between the player and the herding point for displaying the marker.
    MarkerRenderingDistance = 25.0,

    -- Herding points for the cows, goats or sheep to go - once reached the last point, they will be teleported back into the ranch (their position)
    -- (!) Herding Points are also the maximum animals that go out for herding.
    HerdingPoints = {

        RGBA = {r = 255, g = 255, b = 255, a = 55},

${FormatLua(HERDING_LATEST_HERDING_POINTS_CONFIG_DATA, "        ", true)}
    },

    WolfAttack = {

        Enabled = ${wolfEnabled},

        -- Once herding starts, the system checks for a wolf attack. What should be the chance to have a wolf attack?
        -- Set to 0 to never have any wolf attacks (this is for all ranches).
        Chance = ${wolfAttackChance}, -- 0 of 100 %  

        
        -- Once herding started, what should be the distance for wolves to attack when a player is near to the @Coords ?
        AttackNearPlayerPosition = { 
            Coords = ${defaultWolfSpawnPoint}, -- default position is #1 Wolf spawnpoint
            Distance = 70.0,
        },

        -- The SpawnPoints are the spawned wolves and their locations
        -- (!) Permitted Models { a_c_wolf, a_c_wolf_medium, a_c_wolf_small, mp_a_c_wolf_01 }
        SpawnPoints = {

${HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA == null ? "" : FormatLua(HERDING_WOLF_SPAWN_POINTS_CONFIG_DATA, "            ", true)}
        },
    },
},
    `;

    RETRIEVED_CLASS_CONFIG_DATA = `[INSERT_RANCH_UNIQUE_ID_HERE] = {\n${Indent(ranchConfig)}\n},`;

    const el = document.getElementById("config-data-message");

    function escapeHtml(str) {
      return str
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");
    }

    function highlightLua(code) {
      code = escapeHtml(code);

      const spans = [];

      function protect(regex, wrapClass) {
        code = code.replace(regex, (match) => {
          // Removed the accidental space in the token
          const token = `__TOKEN_${spans.length}__`;

          // Fixed HTML spacing
          spans.push(`<span class="${wrapClass}">${match}</span>`);

          return token;
        });
      }

      // 1. comments
      protect(/--.*$/gm, "lua-comment");

      // 2. strings
      protect(/(['"])(.*?)\1/g, "lua-string");

      // 3. booleans
      protect(/\b(true|false)\b/g, "lua-bool");

      // 4. numbers
      protect(/\b\d+(\.\d+)?\b/g, "lua-number");

      // 5. brackets
      protect(/[\{\}\(\)\[\]]/g, "lua-bracket");

      // 6. commas
      protect(/,/g, "lua-comma");

      // Restore tokens
      code = code.replace(/__TOKEN_(\d+)__/g, (_, i) => spans[Number(i)]);

      return `<span class="lua-base">${code}</span>`;
    }

    const formatted = highlightLua(RETRIEVED_CLASS_CONFIG_DATA);

    el.innerHTML = formatted;

    $(".config-data-dialog").fadeIn();

  };


});
