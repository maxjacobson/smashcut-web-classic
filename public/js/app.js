// welcome to hell, kid

require(['jquery', 'alertify.min', 'animate_logo', 'garlic.min'], function ($, alertify) {
  $(document).ready(function () {
    $.get('/fountain/demo.txt', function(demo) {

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
              alertify.log("Please dont judge my writing.", "info");
            } else {
              alertify.log("Demo canceled!", "canceled");
            }
          });
        }
      });

      //clear all text from fountain box
      $("#clear").click(function() {
        var current_text = $("#fountain").val();
        if (current_text === "") {
          alertify.error("Already cleared!");
        } else if (current_text == demo) { // eh, you can clear that w/o confirming
          $("#fountain").val("");
          alertify.log("Now get writing!", "nag");
          alertify.success("Cleared away demo!!");
        } else {
          alertify.confirm("You sure?", function (yep) {
            if (yep) {
              $("#fountain").val("");
              alertify.success("Cleared!");
            } else {
              alertify.log ("Clear canceled!", "canceled");
            }
          });
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
          $("#specify_filename").val(name.replace(/\..+$/, "")); // hmm
          alertify.log ("Loaded " + name);
        };
        if (name.match(pattern)) {
          var current_text = $("#fountain").val();
          if (current_text === "" || current_text == demo) {
            reader.readAsText(selected_file);
          } else {
            alertify.confirm("This will replace the current text.", function (yep) {
              if (yep) {
                reader.readAsText(selected_file);
              } else {
                alertify.log ("Canceled!", "canceled");
              }
            });
          }
        } else {
          alertify.alert("Bad file extension. Please use .fountain");
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