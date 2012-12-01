def determine_center (line)
  return 252 - (288/85) * line.length
end

def add_emphasis (line)
  emph = Hash.new
  emph["emphasis"] = /(_|\*{1,3}|_\*{1,3}|\*{1,3}_)(.+)(_|\*{1,3}|_\*{1,3}|\*{1,3}_)/
  emph["bold_italic_underline"] = /(_{1}\*{3}(?=.+\*{3}_{1})|\*{3}_{1}(?=.+_{1}\*{3}))(.+?)(\*{3}_{1}|_{1}\*{3})/
  emph["bold_underline"] = /(_{1}\*{2}(?=.+\*{2}_{1})|\*{2}_{1}(?=.+_{1}\*{2}))(.+?)(\*{2}_{1}|_{1}\*{2})/
  emph["italic_underline"] = /(?:_{1}\*{1}(?=.+\*{1}_{1})|\*{1}_{1}(?=.+_{1}\*{1}))(.+?)(\*{1}_{1}|_{1}\*{1})/
  emph["bold_italic"] = /(\*{3}(?=.+\*{3}))(.+?)(\*{3})/
  emph["bold"] = /(\*{2}(?=.+\*{2}))(.+?)(\*{2})/
  emph["italic"] = /(\*{1}(?=.+\*{1}))(.+?)(\*{1})/
  emph["underline"] = /(_{1}(?=.+_{1}))(.+?)(_{1})/
  if line =~ emph["emphasis"]
    if line =~ emph["bold_italic_underline"]
      line.sub!(emph["bold_italic_underline"], "<b><i><u>#{$2}</u></i></b>")
    end
    if line =~ emph["bold_underline"]
      line.sub!(emph["bold_underline"], "<b><u>#{$2}</u></b>")
    end
    if line =~ emph["italic_underline"]
      line.sub!(emph["italic_underline"], "<i><u>#{$2}</u></i>")
    end
    if line =~ emph["bold_italic"]
      line.sub!(emph["bold_italic"], "<b><i>#{$2}</i></b>")
    end
    if line =~ emph["bold"]
      line.sub!(emph["bold"], "<b>#{$2}</b>")
    end
    if line =~ emph["italic"]
      line.sub!(emph["italic"], "<i>#{$2}</i>")
    end
    if line =~ emph["underline"]
      line.sub!(emph["underline"], "<u>#{$2}</u>")
    end
  end
  return line
end
