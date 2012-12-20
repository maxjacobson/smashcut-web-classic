# would be cool if verbose scripts (with comments/boneyards/etc) had some js
#embedded that made them appear much like scriptnotes that you can click on and have pop up!!

module To_html
  def title_page_tokens_and_metadata_to_html(title_page, tokens, metadata)
    timer_start = Time.now

    html = <<CHUNK
<!DOCTYPE HTML>
<html lang="en-US">
<head>
  <meta charset="UTF-8">
  <title>#{metadata[:title]} by #{metadata[:author]}</title>
  <meta name="author" content="#{metadata[:author]}">
  <style media="screen" type="text/css">
    body {
      font-family: "Courier",Serif;
      margin: 10px 0;
    }
    body {
      width: 600px;
      margin-left: auto;
      margin-right: auto;
    }
    .dialog_block {
      width: 300px;
      margin: 20px auto;
    }
    .dialog_block p {
      margin: 0;
    }
    .dialog_block .character {
      margin-left: 50px;
    }
    .dialog_block .paren {
      margin-left: 35px;
    }
    .underline {
      text-decoration: underline;
    }
    .centered {
      width = 50%;
      margin-left: auto;
      margin-right: auto;
    }
    h2 {
      font-weight: normal;
      font-size: 1em;
    }
    .transition {
      text-align: right;
    }
    .section, .single_line_note, .boneyard {
      background-color: yellow;
      padding: 5px;
      border-radius: 5px;
      color: green;
      font-family: "Helvetica",Sans-Serif;
    }
    @media only screen and (max-width: 600px) {
      body {
        width: 100%;
      }
      .dialog_block {
        width: 60%;
      }
      .dual_dialog_block {
        width: 60%;
      }
    }
CHUNK

    html = "#{html}\n  </style>\n</head>\n<body>\n"
    if metadata[:has_title_page] == true
      html << "  <div class=\"title_page\">\n"
      title_page[:center].each do |token|
        html << "    <h1>#{token}</h1>\n"
      end
      html << "  </div>\n"

      html << "  <hr />\n"
    end

    tokens.each do |token|
      if token[:data].class == String
        if token[:element] == :slug
          html << "  <h2 class=\"#{token[:element]}\">#{hemphasize(token[:data])}</h2>\n"
        elsif token[:element] == :centered
          html << "  <center>#{hemphasize(token[:data])}</center>\n"
        elsif token[:element] == :section or token[:element] == :single_line_note or token[:element] == :boneyard
          if metadata[:include_comments] == true
            html << "  <p class=\"#{token[:element]}\">#{hemphasize(token[:data])}</p>\n"
          end
        else
          html << "  <p class=\"#{token[:element]}\">#{hemphasize(token[:data])}</p>\n"
        end
      elsif token[:data].class == Array
        html << "  <div class=\"#{token[:element]}\">\n"
        token[:data].each do |subtoken|
          html << "    <p class=\"#{subtoken[:element]}\">#{hemphasize(subtoken[:data])}</p>\n"
        end
        html << "  </div>\n"
      else
      end
    end

    html << "</body>\n</html>"
    puts "Made html in #{Time.now - timer_start} seconds"
    return html
  end

  def hemphasize (data)
    emph = /(_|\*{1,3}|_\*{1,3}|\*{1,3}_)(.+)(_|\*{1,3}|_\*{1,3}|\*{1,3}_)/
    biu = /(_{1}\*{3}(?=.+\*{3}_{1})|\*{3}_{1}(?=.+_{1}\*{3}))(.+?)(\*{3}_{1}|_{1}\*{3})/
    bu = /(_{1}\*{2}(?=.+\*{2}_{1})|\*{2}_{1}(?=.+_{1}\*{2}))(.+?)(\*{2}_{1}|_{1}\*{2})/
    iu = /(?:_{1}\*{1}(?=.+\*{1}_{1})|\*{1}_{1}(?=.+_{1}\*{1}))(.+?)(\*{1}_{1}|_{1}\*{1})/
    bi = /(\*{3}(?=.+\*{3}))(.+?)(\*{3})/
    b = /(\*{2}(?=.+\*{2}))(.+?)(\*{2})/
    i = /(\*{1}(?=.+\*{1}))(.+?)(\*{1})/
    u = /(_{1}(?=.+_{1}))(.+?)(_{1})/
    str = data.dup
    str.gsub!(biu, '<strong><em><span class="underline">\2</span></em></strong>')
    str.gsub!(bu, '<strong><span class="underline">\2</span></strong>')
    str.gsub!(iu, '<em><span class="underline">\2</span></em>')
    str.gsub!(bi, '<strong><em>\2</em></strong>')
    str.gsub!(b, '<strong>\2</strong>')
    str.gsub!(i, '<em>\2</em>')
    str.gsub!(u, '<span class="underline">\2</span>')
    return str
  end

end