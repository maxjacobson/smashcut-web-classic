// welcome to hell, kid

$(document).ready(function () {

  var defaults = {
    file_format: "pdf",
    comments: "exclude",
    medium: "film"
  },
    options = {},
    current_url = document.URL;

  if (current_url.match(/\?file_format/)) {
    var parse_options = current_url.match(/\?file_format=(.+)&comments=(.+)&medium=(.+)$/);
    options.file_format = parse_options[1];
    options.comments = parse_options[2];
    options.medium = parse_options[3];
  } else {
    options = defaults;
  }

  if (options.file_format === "html") {
    $("#file_format_html").attr("checked", "yes");
  } else {
    $("#file_format_pdf").attr("checked", "yes");
  }

  if (options.comments === "include") {
    $("#comments_include").attr("checked", "yes");
  } else {
    $("#comments_exclude").attr("checked", "yes");
  }

  if (options.medium === "musical") {
    $("#medium_musical").attr("checked", "yes");
  } else if (options.medium === "tv") {
    $("#medium_tv").attr("checked", "yes");
  } else {
    $("#medium_film").attr("checked", "yes");
  }

  // uses a plugin to autosize the textarea as it gets populated
  $("#fountain").autosize({append: "\n"});

  if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {
    // should I detect other stuff?
    $("#load_button").remove();
  } else {
  }
  if ($(document).width() <= 300) {
    $("button").addClass("btn-mini");
  } else if ($(document).width() <= 480) {
    $("button").addClass("btn-small");
  }

  $(window).resize(function() {
    var current_width = $(window).width();
    if (current_width <= 480) {
      $("button").addClass("btn-small");
      if (current_width <= 300) {
        $("button").addClass("btn-mini");
      }
    } else {
      $("button").removeClass("btn-small");
      $("button").removeClass("btn-mini");
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
        insert_demo();
      } else {
        var conf = confirm("This will replace the current text.");
        if (conf === true) {
          insert_demo();
        } else {
        }
      }
    });

    //clear all text from fountain box
    $("#clear").click(function() {

      var clear_all = function() {
        $("#fountain").val("").trigger('autosize');
        $("#specify_filename").val("");
        // $("#load").val("");
      };

      var current_text = $("#fountain").val();
      if (current_text === "" || current_text === demo) {
        clear_all();
      } else {
        var conf = confirm("You sure?");
        if (conf === true) {
          clear_all();
        }
      }

    });

    // will submit the form
    $("#smash").click(function () {
      var current_text = $("#fountain").val();
      alert("disabled for now");
      // $("#screenplay_form").submit();
      // fix this: you can hit enter in the filename box to avoid this logic
      // you can submit blank pages if you just avoid clicking that button
      // so bind to the whole submit event somehow http://api.jquery.com/submit/
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
        var current_text = $("#fountain").val();
        var new_text = event.target.result;
        var load_new_file = function(new_text, name) {
          $("#fountain").val(new_text).trigger('autosize');
          $("#specify_filename").val(name.replace(/\..+$/, "")); // removes file extension from filename and puts in the little box... should it?
        };
        if (new_text === current_text || current_text === "" || current_text === demo) {
          load_new_file(new_text, name);
        } else {
          var conf = confirm("This will replace the current text.");
          if (conf === true) {
            load_new_file(new_text, name);
          }
        }
      };
      if (name.match(pattern)) {
        reader.readAsText(selected_file);
      } else {
        alert("Bad file extension. Please use .fountain");
      }
      $("#load").val(""); // unloading the file from the file input, so you can load it again after clearing if you want
    });

    $("input:radio").change(function() {
      var opt = this.name;
      var new_val = this.value;
      if (opt === "file_format") {
        options.file_format = new_val;
      } else if (opt === "comments") {
        options.comments = new_val;
      } else if (opt === "medium") {
        options.medium = new_val;
      }
      console.log(options);
      var url_str = "?file_format="+options.file_format+"&comments="+options.comments+"&medium="+options.medium;
      if (options === defaults) {
        // alert("back to defaults");
        console.log("back to defaults?");
        console.log("options: " + options);
        console.log("defaults: " + defaults);
      }
      history.pushState(options, "updated options", url_str);
    });


  });
});
