

document.addEventListener("DOMContentLoaded", function () {

  document.body.style.display = 'none';

  $("#main").fadeOut();

  displayPage("main-cost", "visible");
  $(".main-cost").fadeOut();

  displayPage("main-required-jobs", "visible");
  $(".main-required-jobs").fadeOut();

  displayPage("main-coords", "visible");
  $(".main-coords").fadeOut();

  displayPage("animal-store", "visible");
  $(".animal-store").fadeOut();

  displayPage("milk-container", "visible");
  $(".milk-container").fadeOut();

  displayPage("water-barrel", "visible");
  $(".water-barrel").fadeOut();

  displayPage("hay-barrel", "visible");
  $(".hay-barrel").fadeOut();

  displayPage("pitch-fork", "visible");
  $(".pitch-fork").fadeOut();

  displayPage("cauldron", "visible");
  $(".cauldron").fadeOut();

  displayPage("animals", "visible");
  $(".animals").fadeOut();

  displayPage("exit-dialog", "visible");
  $(".exit-dialog").fadeOut();

  displayPage("config-data-dialog", "visible");
  $(".config-data-dialog").hide();

  displayPage("placement-info", "visible");
  $(".placement-info").hide();

  displayPage("animals-cow", "visible");
  $(".animals-cow").hide();

  displayPage("animals-goat", "visible");
  $(".animals-goat").hide();

  displayPage("animals-sheep", "visible");
  $(".animals-sheep").hide();

  displayPage("animals-chicken", "visible");
  $(".animals-chicken").hide();

  displayPage("animals-pig", "visible");
  $(".animals-pig").hide();

  displayPage("animals-actions", "visible");
  $(".animals-actions").hide();

  displayPage("herding", "visible");
  $(".herding").hide();

  displayPage("herding-spawn-points", "visible");
  $(".herding-spawn-points").hide();

  displayPage("herding-herding-points", "visible");
  $(".herding-herding-points").hide();

  displayPage("herding-wolf-attacks", "visible");
  $(".herding-wolf-attacks").hide();

  $("#main-back-button").hide();
  $("#main-config-data-button").hide();

  ClearAll();
  //displayPage("notification", "visible");
  //$(".notification").fadeOut();
});

function PlayButtonClickSound() {
  var audio = new Audio('./audio/button_click.wav');
  audio.volume = 0.2;
  audio.play();
}

function displayPage(page, cb) {
  document.getElementsByClassName(page)[0].style.visibility = cb;

  [].forEach.call(document.querySelectorAll('.' + page), function (el) {
    el.style.visibility = cb;
  });
}

function ResetCooldown() { setTimeout(function () { HAS_COOLDOWN = false; }, 500); }

function ClearAll() {
  $("#item_radio").prop("checked", false);
  $("#not_item_radio").prop("checked", true);

  $("#hay_display_icon_radio").prop("checked", true);
  $("#hay_not_display_icon_radio").prop("checked", false);

  $("#wolf_attacks_disabled_radio").prop("checked", true);
  $("#wolf_attacks_enabled_radio").prop("checked", false);

  $("#main-cost-method-input").val('');
  $("#main-cost-input").val('');

  $("#main-required-jobs-input").val('false');

  $("#main-coords-position-input").val('vector3(0,0,0)');

  $("#milk-container-position-input").val('{ x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0, render_distance = 20.0 }');
  $("#milk-container-deliver-input").val('{ x = 0, y = 0, z = 0, action_distance = 0.9 }');

  $("#water-barrel-position-input").val('{ x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0, render_distance = 20.0 }');

  $("#hay-barrel-position-input").val('{ x = 0, y = 0, z = 0 }');

  $("#pitch-fork-position-input").val('{ x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0 }');

  $("#cauldron-position-input").val('{ object = "p_cauldron01x", x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0 }');
  $("#cauldron-teleport-input").val('{ x = 0, y = 0, z = 0, h = 0 }');

  $("#animals-cow-amount-input").val('0');
  $("#animals-sheep-amount-input").val('0');
  $("#animals-goat-amount-input").val('0');
  $("#animals-chicken-amount-input").val('0');
  $("#animals-pig-amount-input").val('0');

  $("#herding-wolf-attacks-chance-input").val('30');

  $("#animals-actions-create-button").hide();
}

function HideAll() {

  $("#main-buttons-list").html('');
  $("#main-back-button").hide();
  $("#main-config-data-button").hide();
  $("#main-exit-button").show();
  $("#main-all-config-data-button").show();
  $(".main-cost").hide();
  $(".main-required-jobs").hide();
  $(".main-coords").hide();
  $(".animal-store").hide();
  $(".milk-container").hide();
  $(".water-barrel").hide();
  $(".hay-barrel").hide();
  $(".pitch-fork").hide();
  $(".cauldron").hide();
  $(".animals-cow").hide();
  $(".animals-goat").hide();
  $(".animals-sheep").hide();
  $(".animals-chicken").hide();
  $(".animals-pig").hide();
  $(".animals-actions").hide();
  $(".exit-dialog").hide();
  $(".config-data-dialog").hide();
  $(".animals").hide();
  $(".herding").hide();
  $(".herding-spawn-points").hide();
  $(".herding-herding-points").hide();
  $("#animals-actions-create-button").hide();
  $(".herding-wolf-attacks").hide();

  $("#item_radio").prop("checked", false);
  $("#not_item_radio").prop("checked", true);
  $("#hay_display_icon_radio").prop("checked", true);
  $("#hay_not_display_icon_radio").prop("checked", false);

  $("#wolf_attacks_disabled_radio").prop("checked", true);
  $("#wolf_attacks_enabled_radio").prop("checked", false);
}

let notificationTimeout; // store timeout globally

function SendNotification(text, color, cooldown) {
  $("#notification_message").text("");
  $("#notification_message").fadeOut();

  // Default cooldown
  cooldown = (cooldown == null || cooldown === 0 || cooldown === undefined) ? 4000 : cooldown * 1000;

  // Clear any previous timeout
  if (notificationTimeout) {
    clearTimeout(notificationTimeout);
    notificationTimeout = null;
  }

  // Update message
  $("#notification_message").text(text);
  $("#notification_message").css("color", color);
  $("#notification_message").fadeIn();

  // Set new timeout
  notificationTimeout = setTimeout(function () {
    $("#notification_message").text("");
    $("#notification_message").fadeOut();
    notificationTimeout = null; // clear reference
  }, cooldown);
}

function RequestNotification(text, type) {
  $.post('http://tp_ranch_creator/requestNotification', JSON.stringify({ message: text, messageType: type }));
}

function onNumbers(evt) {
  // Only ASCII character in that range allowed
  let ASCIICode = (evt.which) ? evt.which : evt.keyCode;

  if (ASCIICode > 31 && (ASCIICode < 48 || ASCIICode > 57))
    return false;
  return true;
}

function parseXYZ(input) {
  const x = input.match(/x\s*=\s*(-?\d+(\.\d+)?)/);
  const y = input.match(/y\s*=\s*(-?\d+(\.\d+)?)/);
  const z = input.match(/z\s*=\s*(-?\d+(\.\d+)?)/);

  if (!x || !y || !z) {
    return "{ x = 0, y = 0, z = 0 }";
  }

  return `{ x = ${x[1]}, y = ${y[1]}, z = ${z[1]} }`;
}

function parseXYZWithPRY(input) {
  const x = input.match(/x\s*=\s*(-?\d+(?:\.\d+)?)/);
  const y = input.match(/y\s*=\s*(-?\d+(?:\.\d+)?)/);
  const z = input.match(/z\s*=\s*(-?\d+(?:\.\d+)?)/);
  const pitch = input.match(/pitch\s*=\s*(-?\d+(?:\.\d+)?)/);
  const roll = input.match(/roll\s*=\s*(-?\d+(?:\.\d+)?)/);
  const yaw = input.match(/yaw\s*=\s*(-?\d+(?:\.\d+)?)/);
  const dist = input.match(/render_distance\s*=\s*(-?\d+(\.\d+)?)/);

  if (!x || !y || !z || !pitch || !roll || !yaw) {
    return "{ x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0, render_distance = 20.0 }";
  }

  return `{ x = ${x[1]}, y = ${y[1]}, z = ${z[1]}, pitch = ${pitch[1]}, roll = ${roll[1]}, yaw = ${yaw[1]}, render_distance = ${dist ? dist[1] : 0} }`;
}

function parseXYZWithPRY2(input) {
  const x = input.match(/x\s*=\s*(-?\d+(?:\.\d+)?)/);
  const y = input.match(/y\s*=\s*(-?\d+(?:\.\d+)?)/);
  const z = input.match(/z\s*=\s*(-?\d+(?:\.\d+)?)/);
  const pitch = input.match(/pitch\s*=\s*(-?\d+(?:\.\d+)?)/);
  const roll = input.match(/roll\s*=\s*(-?\d+(?:\.\d+)?)/);
  const yaw = input.match(/yaw\s*=\s*(-?\d+(?:\.\d+)?)/);

  if (!x || !y || !z || !pitch || !roll || !yaw) {
    return "{ x = 0, y = 0, z = 0, pitch = 0, roll = 0, yaw = 0 }";
  }

  return `{ x = ${x[1]}, y = ${y[1]}, z = ${z[1]}, pitch = ${pitch[1]}, roll = ${roll[1]}, yaw = ${yaw[1]} }`;
}

function parseXYZWithHeading(input) {
  const x = input.match(/x\s*=\s*(-?\d+(?:\.\d+)?)/);
  const y = input.match(/y\s*=\s*(-?\d+(?:\.\d+)?)/);
  const z = input.match(/z\s*=\s*(-?\d+(?:\.\d+)?)/);
  const heading = input.match(/h\s*=\s*(-?\d+(?:\.\d+)?)/);
  if (!x || !y || !z || !heading) {
    return "{ x = 0, y = 0, z = 0, h = 0 }";
  }

  return `{ x = ${x[1]}, y = ${y[1]}, z = ${z[1]}, h = ${heading[1]} }`;
}

function parseXYZWithDistance(input) {
  const x = input.match(/x\s*=\s*(-?\d+(\.\d+)?)/);
  const y = input.match(/y\s*=\s*(-?\d+(\.\d+)?)/);
  const z = input.match(/z\s*=\s*(-?\d+(\.\d+)?)/);
  const dist = input.match(/action_distance\s*=\s*(-?\d+(\.\d+)?)/);

  if (!x || !y || !z) {
    return "{ x = 0, y = 0, z = 0, action_distance = 0 }";
  }

  return `{ x = ${x[1]}, y = ${y[1]}, z = ${z[1]}, action_distance = ${dist ? dist[1] : 0} }`;
}