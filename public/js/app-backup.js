// welcome to hell, kid

$(document).ready(function () {

  var defaults = {
    file_format: "pdf",
    comments: "exclude",
    medium: "film"
  },
    options = {},
    current_url = document.URL;

  var format_pattern = /to\=(\w+)/;
  if (current_url.match(format_pattern)) {
    options.file_format = current_url.match(format_pattern)[1];
  } else {
    options.file_format = defaults.file_format;
  }

  var comment_pattern = /com\=(\w+)/;
  if (current_url.match(comment_pattern)) {
    options.comments = current_url.match(comment_pattern)[1];
  } else {
    options.comments = defaults.comments;
  }

  var medium_pattern = /med\=(\w+)/;
  if (current_url.match(medium_pattern)) {
    options.medium = current_url.match(medium_pattern)[1];
  } else {
    options.medium = defaults.medium;
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

  // uses Jack L. Moore's autosize plugin to autosize the textarea
  $("#fountain").autosize({append: "\n"});

  if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) { // should I detect other stuff?
    $("#load_button").remove();
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

    // the actual file input is hidden so this button is
    // forwarding the click event to its invisible friend
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


    // updates the URL to reflect the current settings
    // so they can be bookmarked
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
      if (options.file_format === "pdf" && options.comments === "exclude" && options.medium === "film") {
        history.pushState(options, "back to default", "/");
      } else {
        var url_str = "/?";
        if (options.file_format !== "pdf") {
          url_str = url_str + "to=" + options.file_format;
        }
        if (options.comments !== "exclude") {
          if (options.file_format !== "pdf") {
            url_str = url_str + "&";
          }
          url_str = url_str + "com=" + options.comments;
        }
        if (options.medium !== "film") {
          if (options.file_format !== "pdf" || options.comments !== "exclude") {
            url_str = url_str + "&";
          }
          url_str = url_str + "med=" + options.medium;
        }
        history.pushState(options, "updated options", url_str);
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


  });
});
