# welcome to hell, kid

$(document).ready ->

  defaults = # sensible defaults
    file_format: "pdf"
    comments: "exclude"
    medium: "film"
  options = {}

  current_url = document.URL

  format_pattern = /to\=(\w+)/
  if current_url.match format_pattern
    options.file_format = current_url.match(format_pattern)[1]
  else
    options.file_format = defaults.file_format

  comment_pattern = /com\=(\w+)/
  if current_url.match comment_pattern
    options.comments = current_url.match(comment_pattern)[1]
  else
    options.comments = defaults.comments

  medium_pattern = /med\=(\w+)/
  if current_url.match medium_pattern
    options.medium = current_url.match(medium_pattern)[1]
  else
    options.medium = defaults.medium

  if options.file_format is "html"
    $("#file_format_html").attr "checked", "yes"
  else
    $("#file_format_pdf").attr "checked", "yes"

  if options.comments is "include"
    $("#comments_include").attr "checked", "yes"
  else
    $("#comments_exclude").attr "checked", "yes"

  if options.medium is "musical"
    $("#medium_musical").attr "checked", "yes"
  else if options.medium is "tv"
    $("#medium_tv").attr "checked", "yes"
  else
    $("#medium_film").attr "checked", "yes"

  $("#fountain").autosize {append: "\n"}

  $("#load_button").remove() if navigator.userAgent.match /iPod|iPhone|iPad/

  if $(document).width() <= 300
    $("button").addClass "btn-mini"
  else if $(document).width() <= 480
    $("button").addClass "btn-small"

  $(window).resize ->
    current_width = $(window).width()
    if current_width <= 480
      $("button").addClass "btn-small"
      if current_width <= 300
        $("button").addClass "btn-mini"
    else
      $("button").removeClass "btn-small"
      $("button").removeClass "btn-mini"

  $("input:radio").change ->
    opt = this.name
    new_val = this.value
    if opt is "file_format"
      options.file_format = new_val
    else if opt is "comments"
      options.comments = new_val
    else if opt is "medium"
      options.medium = new_val
    if options.file_format is "pdf" and options.comments is "exclude" and options.medium is "film"
      history.pushState options, "back to default", "/"
    else
      url_str = "/?"
      if options.file_format isnt "pdf"
        url_str = "#{url_str}to=#{options.file_format}"
      if options.comments isnt "exclude"
        url_str = "#{url_str}&" if options.file_format isnt "pdf"
        url_str = "#{url_str}com=#{options.comments}"
      if options.medium isnt "film"
        url_str = "#{url_str}&" if options.file_format isnt "pdf" or options.comments isnt "exclude"
        url_str = "#{url_str}med=#{options.medium}"
      history.pushState options, "updated options", url_str

  $("#smash").click ->
    $("#screenplay_form").submit()
  $("#screenplay_form").submit ->
    alert "Form submission is disabled until it works better."
    false # remove this to allow the form to submit

  $.get '/fountain/demo.txt', (demo) -> # everything after this needs access to the demo text

    $("#demo").click ->
      insert_demo = ->
        $("#fountain").val(demo).trigger 'autosize'
      current_text = $("#fountain").val()
      if current_text is "" or current_text is demo
        insert_demo()
      else
        insert_demo() if confirm "This will replace the current text."

    $("#clear").click ->
      clear_all = ->
        $("#fountain").val("").trigger('autosize')
        $("#specify_filename").val("")
      current_text = $("#fountain").val()
      if current_text is "" or current_text is demo
        clear_all()
      else
        clear_all() if confirm "You sure?"

    $("#load_button").click ->
      # forwards the click to the hidden file input
      $("#load").click()
    $("#load").on "change", ->
      selected_file = $("#load").get(0).files[0]
      name = selected_file.name
      pattern = /(\.fountain$)|(\.fou$)|(\.txt$)|(\.spmd$)|(\.md$)|(\.markdown$)/
      reader = new FileReader()
      reader.onload = (event) ->
        current_text = $("#fountain").val()
        new_text = event.target.result
        load_new_file = (new_text, name) ->
          $("#fountain").val(new_text).trigger 'autosize'
          $("#specify_filename").val name.replace /\..+$/, ""
        if new_text is current_text or current_text is "" or current_text is demo
          load_new_file(new_text, name)
        else
          load_new_file new_text, name if confirm "This will replace the current text."
      if name.match pattern
        reader.readAsText selected_file
      else
        alert "Bad file extension. Please use .fountain"
      $("#load").val "" # unloading the file from the file input, so you can load it again after clearing