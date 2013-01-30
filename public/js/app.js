// welcome to hell, kid

require(['jquery', 'alertify.min', 'animate_logo', 'garlic.min'], function ($, alertify) {
  $(document).ready(function () {
    if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {
      // should I detect other stuff?
      $("#load_button").css("display", "none");
    }

    if ($(document).width() <= 480) {
      $("button").addClass("btn-small");
    } else if ($(document).width() <= 320) {
      $("button").addClass("btn-mini");
    }

    $.get('/fountain/demo.txt', function(demo) {

      // add demo text to fountain box
      $("#demo").click(function () {
        var current_text = $("#fountain").val();
        if (current_text === "" || current_text == demo) {
          alertify.log( "Please dont judge my writing.", "info" );
          $("#fountain").val(demo);
        } else {
          var conf = confirm("This will replace the current text.");
          if (conf === true) {
            $("#fountain").val(demo);
            alertify.log("Please don't judge my writing.", "info");
          } else {
            alertify.log("Demo canceled!", "canceled");
          }
        }
      });

      //clear all text from fountain box
      $("#clear").click(function() {
        var current_text = $("#fountain").val();
        if (current_text === "") {
          alertify.error("Already cleared!");
          $("#specify_filename").val("");
        } else if (current_text == demo) { // eh, you can clear that w/o confirming
          $("#fountain").val("");
          $("#specify_filename").val("");
          alertify.log("Now get writing!", "nag");
          alertify.success("Cleared away demo!!");
        } else {
          var conf = confirm("You sure?");
          if (conf === true) {
            $("#fountain").val("");
            $("#specify_filename").val("");
            alertify.success("Cleared!");
          } else {
            alertify.log("Clear canceled!", "canceled");
          }
        }
      });

      // the actual file input is hidden so this button is forwarding the click event to its invisible friend
      $("#load_button").on("click", function() {
        $("#load").click();
      });
      $("#load").on("change", function() {
        var selected_file = $("#load").get(0).files[0];
        var name = selected_file.name;
        var pattern = /(\.fountain$)|(\.fou$)|(\.txt$)|(\.spmd$)|(\.md$)|(\.markdown$)/;
        var reader = new FileReader();
        reader.onload = function(event) {
          $("#fountain").val(event.target.result);
          $("#specify_filename").val(name.replace(/\..+$/, "")); // removes file extension from filename and puts in the little box... should it?
          alertify.log ("Loaded " + name);
        };
        if (name.match(pattern)) {
          var current_text = $("#fountain").val();
          if (current_text === "" || current_text == demo) {
            reader.readAsText(selected_file);
          } else {
            var conf = confirm("This will replace the current text.");
            if (conf === true) {
              reader.readAsText(selected_file);
            } else {
              alertify.log("Canceled!", "canceled");
            }
          }
        } else {
          alert("Bad file extension. Please use .fountain");
        }

      });

      $("#smash").click(function () {
        var current_text = $("#fountain").val();
        if (current_text === "") {
          alertify.error("It's blank!");
        } else {
          alertify.error("Processing doesn't work yet");
          // alertify.log("Processing...", "thinking");
          // $("#screenplay_form").submit();
          // fix this: you can hit enter in the filename box to avoid this logic
          // you can submit blank pages if you just avoid clicking that button
          // so bind to the whole submit event somehow http://api.jquery.com/submit/
        }
      });
    });
  });
});