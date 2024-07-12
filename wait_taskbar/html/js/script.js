var cancelledTimer = null;

$('document').ready(function() {
    MythicProgBar = {};

    MythicProgBar.Progress = function(data) {
        clearTimeout(cancelledTimer);
        $(".progress-container").addClass("show");
        $("#progress-label").text(data.label);
        $("#progress-bar").stop().css({"width": 0, "background-image": "repeating-linear-gradient(#98D4e0, #0e718b);"}).animate({
          width: '103%'
        }, {
          duration: parseInt(data.duration),
          complete: function() {
            $(".progress-container").removeClass("show");
            $("#progress-bar").css("width", 0);
            $.post(`https://${GetParentResourceName()}/actionFinish`, JSON.stringify({
                })
            );
          }
        });
    };

    MythicProgBar.ProgressCancel = function() {
        $(".progress-container").addClass("show");
        $("#progress-label").text("ANULOWANO");
        $("#progress-bar").stop().css( {"width": "103%", "background-color": "#0e718b"});

        cancelledTimer = setTimeout(function () {
            $(".progress-container").removeClass("show");
            $("#progress-bar").css("width", 0);
            $.post(`https://${GetParentResourceName()}/actionCancel`, JSON.stringify({
                })
            );
        }, 1000);
    };

    MythicProgBar.CloseUI = function() {
        $('.main-container').css({"display":"none"});
        $(".character-box").removeClass('active-char');
        $(".character-box").attr("data-ischar", "false")
        $("#delete").css({"display":"none"});
    };
    
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case 'mythic_progress':
                MythicProgBar.Progress(event.data);
                break;
            case 'mythic_progress_cancel':
                MythicProgBar.ProgressCancel();
                break;
        }
    })
});