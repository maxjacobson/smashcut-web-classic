def cap_first (s)
  # this code via stack overflow http://stackoverflow.com/questions/2646709/capitalize-only-first-character-of-string-and-leave-others-alone-rails
  return s.slice(0,1).capitalize + s.slice(1..-1)
end

def text_to_html (txt)
  txt.gsub!(/\n/, '<br />')
  txt = "<hr />\n" + txt
  return txt
end