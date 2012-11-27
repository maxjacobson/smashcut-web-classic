timer_start = Time.now
filename = ARGV.first
screenplay = File.open(filename)
puts "\nGlancing over #{filename}."
require 'progress_bar'

lines = Array.new
tokens = Array.new
metadata = Hash.new

regex = Hash.new
regex["slug"] = /^((?:\*{0,3}_?)?(?:(?:int|ext|est|i\/e)[. ]).+)|^(?:\.(?!\.+))(.+)/i
regex["character"] = /^([A-Z ().'0-9\^]+)+$/
regex["paren"] = /^(\(.+\))$/
regex["pagebreak"] = /^\={3,}$/
regex["centered"] = /^(?:> *)(.+)(?: *<)(\n.+)*/
regex["transition"] = /^((?:FADE (?:TO BLACK|OUT)|CUT TO BLACK|FADE IN)\.|.+ TO\:)|^(?:> *)(.+)/
regex["title_page"] = /^((?:title|credit|author[s]?|source|notes|draft date|date|contact|copyright)\:)/im # /gim was there...
regex["boneyard"] = /(^\/\*|^\*\/)$/#/g
regex["section"] = /^(#+)(?: *)(.*)/
regex["synopsis"] = /^(?:\=(?!\=+) *)(.*)/
regex["emphasis"] = /(_|\*{1,3}|_\*{1,3}|\*{1,3}_)(.+)(_|\*{1,3}|_\*{1,3}|\*{1,3}_)/ #/g
regex["note"] = /^(?:\[{2}(?!\[+))(.+)(?:\]{2}(?!\[+))$/ # commented out to try something else...
regex["allNotes"] = /(?:\[{2}(?!\[+))(.+)(?:\]{2}(?!\[+))/


actionCount = 0
dialogCount = 0
parenCount = 0
transitionCount = 0
charCount = 0
emphCount = 0
dualCount = 0
notesCount = 0
slugCount = 0
boneyardCount = 0
charDatabase = Hash.new

screenplay.each do |line|
  lines.push(line)
end

i = 0
while i < lines.length # is this right? should it be <=?
  
  lines[i].gsub!(regex["section"], '')
  lines[i].gsub!(regex["synopsis"], '')
  
  if lines[i] =~ regex["emphasis"]
    emphCount += 1
  end
  
  # I don't think this identifies mid-line notes, like
  # Max walks into the bar [[should I say pub?]].
  # but it should probably strip away that note
  
  if lines[i] =~ regex["allNotes"]
    # puts "Identified a note: #{lines[i]}"
    if lines[i] =~ regex["note"] # notes that comprise the full line -- not midline notes
      tokens.push([lines[i], "note"])
    else
      tempNote = lines[i].match(regex["allNotes"])
      puts "Have I extracted the note? #{tempNote}"
      tokens.push([tempNote, "note"])
      lines[i].gsub!(regex["allNotes"], '')
      puts "Does the rest of the line remain? #{lines[i]}"
    end
    notesCount += 1
  end
  
  if lines[i] == "\n"
    #nothing I guess
  elsif lines[i-1] == "\n" and lines[i+1] != "\n" and lines[i] =~ regex["character"]
    dialogBlock = Array.new
    inDialogBlock = true
    dialogBlock.push("dialogBlock")
    if lines[i] =~ / *\^$/
      lines[i].sub!(/ *\^$/, "") #removes the caret
      dialogBlock.push(["characterDual2", lines[i]])
      tokens[-1][1][0] = "characterDual1"
      dualCount += 1
    else
      dialogBlock.push(["character", lines[i]])
    end
    tempChar = lines[i].gsub(/\n/,'') #removes line ending
    tempChar = tempChar.gsub(/ *\([A-Z.' ]+\)/,'') #removes CONT'D or VO type stuff
    if charDatabase[tempChar].nil?
      charDatabase[tempChar] = 1
      charCount += 1
    else
      charDatabase[tempChar] += 1
    end
    while inDialogBlock == true
      i += 1
      if lines[i] == "\n"
        inDialogBlock = false
      else
        if lines[i] =~ regex["paren"]
          dialogBlock.push(["paren", lines[i]])
          parenCount += 1
        else
          dialogBlock.push(["dialog",lines[i]])
          dialogCount += 1
        end
      end
    end
    tokens.push(dialogBlock)
  elsif lines[i] =~ regex["boneyard"]
    #the boneyard implementation may work or it may not...
    #if you open a boneyard and in the middle use the open code again, that will end it here I think, which it prob shouldn't
    # and what if the entire boneyard opens and closes on one line?
    boneyardBlock = Array.new
    inTheYard = true
    boneyardBlock.push("boneyard")
    while inTheYard == true
      i+=1
      if lines[i] =~ regex["boneyard"]
        inTheYard = false
      else
        boneyardBlock.push(lines[i])
      end
    end
    tokens.push(boneyardBlock)
    boneyardCount += 1
  elsif lines[i] =~ regex["title_page"]
    # problem: supporting multiple authors, supporting other metadata
    lines[i].gsub!(/\n/, '')
    if lines[i] =~ /title/im
      lines[i].gsub!(/title: */im, '')
      metadata["title"] = lines[i]
    elsif lines[i] =~ /credit/im
      lines[i].gsub!(/credit: */im, '')
      metadata["credit"] = lines[i]
    elsif lines[i] =~ /author|authors/im
      lines[i].gsub!(/author: */im, '')
      metadata["author"] = lines[i]
    end
  elsif lines[i] =~ regex["pagebreak"]
    tokens.push(["pagebreak"])
  elsif lines[i] =~ regex["centered"]
    tokens.push([lines[i], "centered"])
  elsif lines[i] =~ regex["transition"]
    tokens.push([lines[i], "transition"])
    transitionCount+=1
  elsif lines[i] =~ regex["slug"]
    tokens.push(lines[i], "slug")
    slugCount += 1
  else
    tokens.push([lines[i], "action"])
    actionCount+=1
  end
  i += 1
end

# puts "\nhere are all of the dialog blocks:\n\n"
# 
# tokens.each do |ch|
#   if ch[0] == "dialogBlock"
#     puts "#{ch}"
#   end
# end

# puts "\nThese are your tokens:\n#{tokens}"
puts "\nAnd here are some stats:"
puts "\nThere are #{actionCount} lines of action."
puts "There are #{slugCount} slugs."
puts "There are #{dialogCount} lines of dialog."
puts "There are #{transitionCount} transitions."
puts "There are #{parenCount} parentheticals."
puts "There are #{emphCount} instances of text emphasis."
puts "There are #{dualCount} instances of dual dialog."
puts "There are #{boneyardCount} boneyards."
puts "There are #{notesCount} notes."
puts "\nThere are #{charCount} characters:"
sortedChars = charDatabase.sort {|a1,a2| a2[1]<=>a1[1]}
sortedChars.each do |c|
  print "#{c[0]} with #{c[1]} lines | "
end
puts "\n\n%.2f seconds elapsed. Now making your pdf from the above tokens...\n\n" % (Time.now - timer_start)



require "prawn"
require "prawn/measurement_extensions" # lets you use inches instead of points (1/72")

def print_title_page (metadata)
  move_cursor_to 7.29.in
  metadata.each_value do |info|
    bounding_box([determine_center(info),cursor], :width=> 4.3.in) do
      text info
      move_down 0.175.in
    end
  end
  start_new_page
  # need to support more metadata like contact info, date, copyright, etc...
  # also, multiple authors
end

def print_ad
  move_cursor_to 7.29.in
  bounding_box([1.5.in,cursor], :width=> 4.3.in) do
    image "ad.png", :width => 4.3.in
  end
  move_down 0.175.in
  bounding_box([2.5.in,cursor], :width=> 4.3.in) do
    text "<font size='18'><u><link href='http://smashcutapp.com'><color rgb='0082FF'>smashcutapp.com</color></link></u></font>", :inline_format => true
  end
  start_new_page
end

def determine_center (line)
  return 252 - (288/85) * line.length
  # return (((85 - line.length) / 2) * 6.776470588) - 36
  # 85 = how many characters go fully across the page
  # 36 = the default margin in prawn
  # 6.776470588 = 576/85, aka the width of a single character
  # afaik prawn doesn't support centering of text
  ##### I've since learned it does, and I use it elsewhere in this script (search `:center`). is this method still necessary?
  # i think this will center it nicely. what it returns will be used as a left margin
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

def print_dialog_block (block)
  # need to implement this
  i = 1
  while i < block.length
    if block[i][0] == "character"
      bounding_box([3.2.in,cursor], :width=> 4.3.in) do
        text block[i][1]
      end
    elsif block[i][0] == "characterDual1"
      text "put dual dialog1 here"
    elsif block[i][0] == "characterDual2"
      text "put dual dialog2 here"
    elsif block[i][0] == "paren"
      bounding_box([2.9.in,cursor], :width => 1.5.in) do
        text add_emphasis(block[i][1]), :inline_format => true
      end
    elsif block[i][0] == "dialog"
      span(2.9.in, :position => :center) do
        text add_emphasis(block[i][1]), :inline_format => true
      end
    end
    i+=1
  end
  move_down 0.175.in
end

########this chunk of notes was in the now-deleted print_dialog method##########################
# ok so I needed to make it a span so that it would flow onto the next page at the top
# later I'll need to write some code to make these page-spans more intelligent
# like, don't go over a page in the middle of a sentence. that's a rule. that's gonna be tricky
# I didn't realize I could do proper centering with span like this so I have to re-consider some other code
# and make sure the margins are correct here
# bounding_box([2.2.in,cursor], :width => 2.9.in) do
#   text line, :inline_format => true
#   move_down 0.175.in
# end
#################################################################################################

#########this chunk of notes was in the unused, now-deleted print_notes method#######################
# notes look like: [[This is a note on one line onely.]] or /*This is a note that can span multiple lines. They call this kind of note a "boneyard" which is so writerly.*/
# I *think* I shouldn't print notes. The way I use them, they're for reference while writing, but don't belong in the pdf
# *BUT* I could see myself wanting to print out a copy with notes in some contexts
# I think this might need to be a checkbox
# By default, notes will just be left out
# But if the checkbox is checked, notes will be printed in some nice way
# The same applies to synopses, which I've never personsally used, but are part of the Fountain spec
# Consider using pdf table of contents to help jump around using this info
# Page 112 of the manual
# consider this http://fountain.io/syntax#section-br
#################################################################################################

def print_slug (slug)
  print_action(slug) #is this ok? slugs follow the same formatting rules as action I think
end

def print_action (line)
  line = add_emphasis(line)
  span(5.2.in, :position => :center) do
    text line, :inline_format => true
  end
  move_down 0.175.in
end

def print_transition (trans)
  line = add_emphasis(line)
  if trans == "FADE IN:"
    span(5.2.in, :position => :center) do
      text trans, :inline_format => true
    end
  else
    bounding_box([5.5.in,cursor], :width => 2.in) do
      text trans, :inline_format => true
    end
  end
  move_down 0.175.in
end

def print_centered (line)
  line.gsub!(/(> *)|( *<)/, '')
  line = add_emphasis(line)
  bounding_box([determine_center(line),cursor], :width=> 4.3.in) do
    text line, :inline_format => true
  end
  move_down 0.175.in
end

def print_page_break
  start_new_page
end

if metadata["title"].nil?
  metadata["title"] = "My Great Screenplay"
end
if metadata["credit"].nil?
  metadata["credit"] = "Written By"
end
if metadata["author"].nil?
  metadata["author"] = "Anon Y. Mouse"
end
if metadata["date"].nil?
  dateNum = Time.now
else
  dateNum = metadata["date"]
end

outputFile = metadata["title"] + ".pdf"

# Check page 118 for page numbers
# check page 108 for a way to create a document with specific margins
# , :margin => [1.in, 0, 1.in, 0]

bar = ProgressBar.new(tokens.length + 2, :percentage, :counter, :bar)

Prawn::Document.generate(outputFile, :info => { :Title => metadata["title"], :Author => metadata["author"], :Creator => "smashcutapp.com", :CreationDate => dateNum}) do
  font("Courier", :size => 12) do
    print_title_page(metadata)
    bar.increment!
    print_ad
    bar.increment!
    tokens.each do |line|
      
      bar.increment!
      
      if line[1] == "transition"
        print_transition(line[0])
      elsif line[1] == "slug"
        print_slug(line[0])
      elsif line[1] == "action"
        print_action(line[0])
      elsif line[0] == "dialogBlock"
        print_dialog_block(line)
      elsif line[1] == "centered"
        print_centered(line[0])
      elsif line[1] == "note" or lines[0] == "boneyard"
        # nothing happens
        # later will add a checkmark to print these, probly as endnotes
      elsif line[0] == "pagebreak" #yes, 0 not 1
        print_page_break
      end
    end
  end
end

puts "Your screenplay is waiting for you in [#{outputFile}]"
puts "Processed in %.2f seconds.\n\n" % (Time.now - timer_start)

screenplay.close()