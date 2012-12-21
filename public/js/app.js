require(['jquery', 'alertify.min', 'animate_logo', 'garlic.min'], function ($, alertify) {
  $(document).ready(function () {
    $.get('/fountain/demo.fountain', function(demo) {
      // add demo text to fountain box
      $("#demo").click(function () {
        var current_text = $("#fountain").val();
        if (current_text === "" || current_text == demo) {
          alertify.log( "Please dont judge my writing.", "info" );
          $("#fountain").val(demo);
        } else {
          alertify.confirm("This will replace the current text.", function (yep) {
            if (yep) {
              //after clicking OK
              $("#fountain").val(demo);
              alertify.log( "Please dont judge my writing.", "info" );
            } else {
              alertify.log( "Demo canceled!", "canceled");
            }
          });
        }
      });

      //clear all text from fountain box
      $("#clear").click(function () {
        var current_text = $("#fountain").val();
        if (current_text === "") {
          alertify.error( "Already cleared!" );
        } else if (current_text == demo) { // eh, you can clear that w/o confirming
          $("#fountain").val("");
          alertify.log("Now get writing!", "nag");
          alertify.success( "Cleared away demo!!" );
        } else {
          alertify.confirm("You sure?", function (yep) {
            if (yep) {
              $("#fountain").val("");
              alertify.success( "Cleared!" );
            } else {
              alertify.log ("Clear canceled!", "canceled");
            }
          });
        }
      });
    });
    $("#smash").click(function () {
      var current_text = $("#fountain").val();
      if (current_text === "") {
        alertify.error("It's blank!");
      } else {
          $("#screenplay_form").submit();
          // fix this: you can hit enter in the filename box to avoid this logic
          // you can submit blank pages if you just avoid clicking that button
          // so bind to the whole submit event somehow http://api.jquery.com/submit/
      }
    });
  });
});