// welcome to hell, kid

require(['jquery', 'alertify.min', 'autosize', 'animate_logo', 'garlic.min'], function ($, alertify) {
  $(document).ready(function () {

    // uses a plugin to autosize the textarea as it gets populated
    $("#fountain").autosize({append: "\n"});

    if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {
      // should I detect other stuff?
      $("#load_button").css("display", "none");
    }

    if ($(document).width() <= 480) {
      $("button").addClass("btn-small");
    }
    $(window).resize(function() {
      var current_width = $(window).width();
      if (current_width <= 480) {
        $("button").addClass("btn-small");
      } else {
        $("button").removeClass("btn-small");
      }
    });

    $.get('/fountain/demo.txt', function(demo) {

      // add demo text to fountain box
      $("#demo").click(function () {
        var insert_demo = function() {
          $("#fountain").val(demo).trigger('autosize');
        };
        var current_text = $("#fountain").val();
        if (current_text === "" || current_text == demo) {
          alertify.log( "Please dont judge my writing.", "info" );
          insert_demo();
        } else {
          var conf = confirm("This will replace the current text.");
          if (conf === true) {
            insert_demo();
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
          $("#fountain").css("height", "350px");
        } else if (current_text == demo) { // eh, you can clear that w/o confirming
          $("#fountain").val("").trigger('autosize');
          $("#specify_filename").val("");
          // $("#fountain").css("height", "350px");
          alertify.log("Now get writing!", "nag");
          alertify.success("Cleared away demo!!");
        } else {
          var conf = confirm("You sure?");
          if (conf === true) {
            $("#fountain").val("").trigger('autosize');
            $("#specify_filename").val("");
            // $("#fountain").css("height", "350px");
            alertify.success("Cleared!");
          } else {
            alertify.log("Clear canceled!", "canceled");
          }
        }
      });



      // will submit the form
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

      // the actual file input is hidden so this button is
      //forwarding the click event to its invisible friend
      $("#load_button").on("click", function() {
        $("#load").click();
      });
      // when a file is selected, it's loaded into the textbox
      $("#load").on("change", function() {
        var selected_file = $("#load").get(0).files[0];
        var name = selected_file.name;
        var pattern = /(\.fountain$)|(\.fou$)|(\.txt$)|(\.spmd$)|(\.md$)|(\.markdown$)/;
        var reader = new FileReader();
        reader.onload = function(event) {
          $("#fountain").val(event.target.result).trigger('autosize');
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


    });
  });
});