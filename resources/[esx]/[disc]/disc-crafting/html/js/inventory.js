var type = "normal";
var firstTier = 1;
var firstUsed = 0;
var firstItems = [];
var secondTier = 1;
var secondUsed = 0;
var secondItems = [];
var errorHighlightTimer = null;
var originOwner = false;
var destinationOwner = false;
var currentSlot = 0;

var mousedown = false;
var docWidth = document.documentElement.clientWidth;
var docHeight = document.documentElement.clientHeight;
var offset = [76, 81];
var cursorX = docWidth / 2;
var cursorY = docHeight / 2;

var successAudio = document.createElement('audio');
successAudio.controls = false;
successAudio.volume = 0.25;
successAudio.src = './success.wav';

var failAudio = document.createElement('audio');
failAudio.controls = false;
failAudio.volume = 0.1;
failAudio.src = './fail.wav';

window.addEventListener("message", function (event) {
    if (event.data.action === "display") {
        $(".ui").fadeIn();
        secondItems = []
    } else if (event.data.action === "hide") {
        $("#dialog").dialog("close");
        $(".ui").fadeOut();
    } else if (event.data.action === "setItems") {
        inventorySetup(event.data.invOwner, event.data.itemList);
        secondInventorySetup(event.data.benchName);
    } else if (event.data.action === "setInfoText") {
        $(".info-div").html(event.data.text);
    } else if(event.data.action === 'crafted') {
        InventoryLog('Crafted!');
        secondItems = [];
        $('#inventoryTwo').html("");
        currentSlot = 0;
    }
});

function closeInventory() {
    InventoryLog('Closing');
    $.post("http://disc-crafting/NUIFocusOff", JSON.stringify({}));
}

function inventorySetup(invOwner, items) {
    $('#inventoryOne').html("");
    $('#player-inv-id').html("");
    $('#inventoryOne').removeData('invOwner');
    $('#player-inv-label').html('Player');
    $('#player-inv-id').html(invOwner);
    $('#inventoryOne').data('invOwner', invOwner);
    let slots = 0;
    $.each(items, function (index, item) {
        $("#inventoryOne").append($('.slot-template').clone());
        $('#inventoryOne').find('.slot-template').data('slot', slots);
        $('#inventoryOne').find('.slot-template').data('inventory', 'inventoryOne');
        $('#inventoryOne').find('.slot-template').removeClass('slot-template');
        let slot = $('#inventoryOne').find('.slot').filter(function () {
            return $(this).data('slot') === slots;
        });
        firstUsed++;
        var slotId = $(slot).data('slot');
        firstItems[slotId] = item;
        AddItemToSlot(slot, item);
        slots++;
    });
}

function addToCraftingBench(item) {
    $("#inventoryTwo").append($('.slot-template').clone());
    $('#inventoryTwo').find('.slot-template').data('slot', currentSlot);
    $('#inventoryTwo').find('.slot-template').data('inventory', 'inventoryTwo');
    $('#inventoryTwo').find('.slot-template').find('.item-count').css('display', 'none');
    $('#inventoryTwo').find('.slot-template').removeClass('slot-template');
    secondItems[currentSlot] = item;
    let slot = $('#inventoryTwo').find('.slot').filter(function () {
        return $(this).data('slot') === currentSlot;
    });
    AddItemToSlot(slot, item);
    currentSlot++
}

function removeFromCraftingBench(slot) {
    $('#inventoryTwo').html("");
    secondItems[slot] = null;
    currentSlot = 0;
    let items = secondItems.filter(function (value) {
        return value !== null
    });
    secondItems = [];
    for (i = 0; i < items.length; i++) {
        addToCraftingBench(items[i])
    }
}

function secondInventorySetup(invOwner) {
    $('#inventoryTwo').html("").removeData('invOwner').data('invOwner', invOwner);
    $('#other-inv-label').html(invOwner);
    $('#other-inv-id').html(invOwner);
}

$(document).ready(function () {

    $('#inventoryOne').on('click', '.slot', function (e) {
        itemData = $(this).find('.item').data('item');
        if (itemData == null) {
            return
        }
        addToCraftingBench(itemData)
    });

    $('#inventoryTwo').on('click', '.slot', function (e) {
        itemData = $(this).find('.item').data('item');
        if (itemData == null) {
            return
        }
        var slot = $(this).data('slot');
        removeFromCraftingBench(slot)
    });

    $('.close-ui').click(function (event, ui) {
        closeInventory();
    });

    $("#craft").mouseenter(function () {
        if (!$(this).hasClass('disabled')) {
            $(this).addClass('hover');
        }
    }).mouseleave(function () {
        $(this).removeClass('hover');
    }).click(function (event, ui) {
        InventoryLog('Attempting Crafting');
        $.post("http://disc-crafting/Craft", JSON.stringify({
            craftingSet : secondItems
        }));
    });

    $("body").on("keyup", function (key) {
        if (Config.closeKeys.includes(key.which)) {
            closeInventory();
        }
    });
});


function ErrorCheck(origin, destination, moveQty) {
    var originOwner = origin.parent().data('invOwner');
    var destinationOwner = destination.parent().data('invOwner');

    if (destinationOwner === undefined) {
        return 1
    }

    var sameInventory = (originOwner === destinationOwner);
    var status = -1;

    if (sameInventory) {
    } else if (originOwner === $('#inventoryOne').data('invOwner') && destinationOwner === $('#inventoryTwo').data('invOwner')) {
        var item = origin.find('.item').data('item');
    } else {
        var item = origin.find('.item').data('item');
    }

    return status
}

function ResetSlotToEmpty(slot) {
    slot.find('.item').addClass('empty-item');
    slot.find('.item').css('background-image', 'none');
    slot.find('.item-count').html(" ");
    slot.find('.item-name').html(" ");
    slot.find('.item').removeData("item");
}

function AddItemToSlot(slot, data) {
    slot.find('.empty-item').removeClass('empty-item');
    slot.find('.item').css('background-image', 'url(\'img/items/' + data.itemId + '.png\')');
    if (data.price !== undefined && data.price !== 0) {
        slot.find('.item-price').html('$' + data.price);
    }
    slot.find('.item-count').html(data.qty);
    slot.find('.item-name').html(data.label);
    slot.find('.item').data('item', data);
}

function ClearLog() {
    $('.inv-log').html('');
}

function InventoryLog(log) {
    $('.inv-log').html(log + "<br>" + $('.inv-log').html());
}

function DisplayMoveError(origin, destination, error) {
    failAudio.play();
    origin.addClass('error');
    destination.addClass('error');
    if (errorHighlightTimer != null) {
        clearTimeout(errorHighlightTimer);
    }
    errorHighlightTimer = setTimeout(function () {
        origin.removeClass('error');
        destination.removeClass('error');
    }, 1000);
    InventoryLog(error);
}

var alertTimer = null;

function ItemUsed(alerts) {
    clearTimeout(alertTimer);
    $('#use-alert').hide('slide', {direction: 'left'}, 500, function () {
        $('#use-alert .slot').remove();

        $.each(alerts, function (index, data) {
            $('#use-alert').append(`<div class="slot alert-${index}""><div class="item"><div class="item-count">${data.qty}</div><div class="item-name">${data.item.label}</div></div><div class="alert-text">${data.message}</div></div>`)
                .ready(function () {
                    $(`.alert-${index}`).find('.item').css('background-image', 'url(\'img/items/' + data.item.itemId + '.png\')');
                    if (data.item.slot <= 5) {
                        $(`.alert-${index}`).find('.item').append(`<div class="item-keybind">${data.item.slot}</div>`)
                    }
                });
        });
    });

    $('#use-alert').show('slide', {direction: 'left'}, 500, function () {
        alertTimer = setTimeout(function () {
            $('#use-alert .slot').addClass('expired');
            $('#use-alert').hide('slide', {direction: 'left'}, 500, function () {
                $('#use-alert .slot.expired').remove();
            });
        }, 2500);
    });
}

var actionBarTimer = null;

function ActionBar(items, timer) {
    if ($('#action-bar').is(':visible')) {
        clearTimeout(actionBarTimer);

        for (let i = 0; i < 5; i++) {
            $('#action-bar .slot').removeClass('expired');
            if (items[i] != null) {
                $(`.slot-${i}`).find('.item-count').html(items[i].qty);
                $(`.slot-${i}`).find('.item-name').html(items[i].label);
                $(`.slot-${i}`).find('.item-keybind').html(items[i].slot);
                $(`.slot-${i}`).find('.item').css('background-image', 'url(\'img/items/' + items[i].itemId + '.png\')');
            } else {
                $(`.slot-${i}`).find('.item-count').html('');
                $(`.slot-${i}`).find('.item-name').html('NONE');
                $(`.slot-${i}`).find('.item-keybind').html(i + 1);
                $(`.slot-${i}`).find('.item').css('background-image', 'none');
            }

            actionBarTimer = setTimeout(function () {
                $('#action-bar .slot').addClass('expired');
                $('#action-bar').hide('slide', {direction: 'down'}, 500, function () {
                    $('#action-bar .slot.expired').remove();
                });
            }, timer == null ? 2500 : timer);
        }
    } else {
        $('#action-bar').html('');
        for (let i = 0; i < 5; i++) {
            if (items[i] != null) {
                $('#action-bar').append(`<div class="slot slot-${i}"><div class="item"><div class="item-count">${items[i].qty}</div><div class="item-name">${items[i].label}</div><div class="item-keybind">${items[i].slot}</div></div></div>`);
                $(`.slot-${i}`).find('.item').css('background-image', 'url(\'img/items/' + items[i].itemId + '.png\')');
            } else {
                $('#action-bar').append(`<div class="slot slot-${i}" data-empty="true"><div class="item"><div class="item-count"></div><div class="item-name">NONE</div><div class="item-keybind">${i + 1}</div></div></div>`);
                $(`.slot-${i}`).find('.item').css('background-image', 'none');
            }
        }

        $('#action-bar').show('slide', {direction: 'down'}, 500, function () {
            actionBarTimer = setTimeout(function () {
                $('#action-bar .slot').addClass('expired');
                $('#action-bar').hide('slide', {direction: 'down'}, 500, function () {
                    $('#action-bar .slot.expired').remove();
                });
            }, timer == null ? 2500 : timer);
        });
    }
}

var usedActionTimer = null;

function ActionBarUsed(index) {
    clearTimeout(usedActionTimer);

    if ($('#action-bar .slot').is(':visible')) {
        if ($(`.slot-${index - 1}`).data('empty') != null) {
            $(`.slot-${index - 1}`).addClass('empty-used');
        } else {
            $(`.slot-${index - 1}`).addClass('used');
        }
        usedActionTimer = setTimeout(function () {
            $(`.slot-${index - 1}`).removeClass('used');
            $(`.slot-${index - 1}`).removeClass('empty-used');
        }, 1000)
    }
}

function LockInventory() {
    locked = true;
    $('#inventoryOne').addClass('disabled');
    $('#inventoryTwo').addClass('disabled');
}

function UnlockInventory() {
    locked = false;
    $('#inventoryOne').removeClass('disabled');
    $('#inventoryTwo').removeClass('disabled');
}