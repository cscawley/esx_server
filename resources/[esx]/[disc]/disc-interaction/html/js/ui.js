var successAudio = document.createElement('audio');
successAudio.controls = false;
successAudio.volume = 0.25;
successAudio.src = './success.wav';

var blacklist = [];
var isInVehicle = false;
var seatMaxIndex = 0;
var doorIndex = 0;

let menus = $('.ui').find('.menu');

let subMenus = $('.ui').find('.sub-menu');
$('.ui').hide();
$('.main-menu').hide();
hideMenus();
hideSubMenus();

window.addEventListener("message", function (event) {
    switch (event.data.action) {
        case 'show':
            $('.ui').fadeIn();
            $('.main-menu').fadeIn();
            blacklist = event.data.blacklist;
            seatMaxIndex = event.data.seatMaxIndex;
            doorIndex = event.data.doorIndex;
            isInVehicle = event.data.isInVehicle;
            if (!isInVehicle) {
                $('#vehicle-toggle').css('display', 'none');
                $('#citizen-toggle').css('display', 'block');
            } else {
                $('#vehicle-toggle').css('display', 'block');
                $('#citizen-toggle').css('display', 'none');
            }
            break;
        case 'hide':
            $('.ui').fadeOut();
            $('.main-menu').fadeOut();
            hideMenus();
            hideSubMenus();
            break;
    }
});

function toggleMenu(menu) {
    if ($(menu).prop('showing')) {
        hideMenu(menu)
    } else {
        showMenu(menu)
    }
}

function hideBlacklist(menu) {

}

function hideMenus() {
    $.each(menus, function (index, value) {
        hideMenu(value)
    })
}

function hideSubMenus() {
    $.each(subMenus, function (index, value) {
        hideMenu(value)
    })
}

function hideMenu(menu) {
    $(menu).hide();
    $(menu).prop('showing', false)
}

function showMenu(menu) {
    $(menu).show();
    $(menu).prop('showing', true)
}

$(document).ready(function () {
    $("#use").mouseenter(function () {
        $(this).addClass('hover');
    }).mouseleave(function () {
        $(this).removeClass('hover');
    });

    $("#citizen-toggle").click(function () {
        hideMenus();
        hideSubMenus();
        toggleMenu($('#citizen-menu'));
    });

    $("#vehicle-toggle").click(function () {
        hideMenus();
        hideSubMenus();
        toggleMenu($('#vehicle-menu'));
    });

    $("#check-toggle").click(function () {
        hideSubMenus();
        toggleMenu($('#check-menu'));
    });

    $("#seat-toggle").click(function () {
        hideSubMenus();
        $('#seat-menu').html("");
        for (var i = -1; i < seatMaxIndex; i++) {
            $('#seat-menu').append(`<div class="button switch-seat" data-seat="${i}">Seat ${i}</div>`)
        }
        toggleMenu($('#seat-menu'));
    });

    $('#seat-menu').on('click', '.switch-seat', function (e) {
        $.post("http://disc-interaction/SwitchSeats", JSON.stringify({
            seat: $(this).data('seat')
        }));
        closeEverything();
    });

    $("#doors-toggle").click(function () {
        hideSubMenus();
        $('#door-menu').html("");
        $('#door-menu').append('<div class="button" id="close-all-doors">Close All</div>');
        $('#door-menu').append('<div class="button" id="open-all-doors">Open All</div>');
        for (var i = 0; i < doorIndex; i++) {
            $('#door-menu').append(`<div class="button toggle-door" data-door="${i}">Door ${i}</div>`)
        }
        toggleMenu($('#door-menu'));
    });

    $('#door-menu').on('click', '.toggle-door', function (e) {
        $.post("http://disc-interaction/ToggleDoor", JSON.stringify({
            door: $(this).data('door')
        }));
        closeEverything();
    });

    $('#door-menu').on('click', '#close-all-doors', function (e) {
        $.post("http://disc-interaction/ToggleDoor", JSON.stringify({
            door: 'all',
            action: 'close'
        }));
        closeEverything();
    });

    $('#door-menu').on('click', '#open-all-doors', function (e) {
        $.post("http://disc-interaction/ToggleDoor", JSON.stringify({
            door: 'all',
            action: 'open'
        }));
        closeEverything();
    });

    $('#drag').click(function () {
        $.post("http://disc-interaction/Drag", JSON.stringify({

        }));
        closeEverything();
    });

    $('#carry').click(function () {
        $.post("http://disc-interaction/Carry", JSON.stringify({

        }));
        closeEverything();
    });
    $('#putinvehicle').click(function () {
        $.post("http://disc-interaction/PutInVehicle", JSON.stringify({

        }));
        closeEverything();
    });

    $('#outofvehicle').click(function () {
        $.post("http://disc-interaction/OutOfVehicle", JSON.stringify({

        }));
        closeEverything();
    });


});

function closeEverything() {
    $.post("http://disc-interaction/NUIFocusOff", JSON.stringify({}));
}

$("body").on("keyup", function (key) {
    if (Config.closeKeys.includes(key.which)) {
        closeEverything()
    }
});