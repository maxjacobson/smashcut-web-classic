def fountain_to_tokens_and_metadata (screenplay)

  timer_start = Time.now
  
  # this doesn't work on strings tho it does on files (weird)
  # lines = Array.new
  # screenplay.each do |line|
  #   lines.push(line)
  # end
  
  lines = screenplay.split(/\n/)
  for i in 0...lines.length
    lines[i].gsub!(/\r/, '')
    lines[i] = lines[i] + "\n"
  end

  tokens = Array.new
  metadata = Hash.new
  metadata[:there_is_a_title_page] = false # TODO temp

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

  i = 0
  while i < lines.length
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
        # puts "Have I extracted the note? #{tempNote}"
        tokens.push([tempNote, "note"])
        lines[i].gsub!(regex["allNotes"], '')
        # puts "Does the rest of the line remain? #{lines[i]}"
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
        metadata[:title] = lines[i]
      elsif lines[i] =~ /credit/im
        lines[i].gsub!(/credit: */im, '')
        metadata[:credit] = lines[i]
      elsif lines[i] =~ /author|authors/im
        lines[i].gsub!(/author: */im, '')
        metadata[:author] = lines[i]
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
  # tokens.each do |ch|
  #   if ch[0] == "dialogBlock"
  #     puts "#{ch}"
  #   end
  # end
  # puts "\nThese are your tokens:\n#{tokens}"
  # puts "\nThere are #{actionCount} lines of action."
  # puts "There are #{slugCount} slugs."
  # puts "There are #{dialogCount} lines of dialog."
  # puts "There are #{transitionCount} transitions."
  # puts "There are #{parenCount} parentheticals."
  # puts "There are #{emphCount} instances of text emphasis."
  # puts "There are #{dualCount} instances of dual dialog."
  # puts "There are #{boneyardCount} boneyards."
  # puts "There are #{notesCount} notes."
  # puts "\nThere are #{charCount} characters."
  # puts "Here they are, sorted:"
  # sortedChars = charDatabase.sort {|a1,a2| a2[1]<=>a1[1]}
  # sortedChars.each do |c|
  #   print "#{c[0]} with #{c[1]} lines | "
  # end
  
  # puts metadata

  puts "Tokenized in %.2f seconds." % (Time.now - timer_start)
  return {:tokens => tokens, :metadata => metadata}
end

# # you can just run this file like so:
# # ruby fountain_to_tokens.rb example.fountain
# # for debugging the tokenizer
# if ARGV.first != nil
#   tokens = fountain_to_tokens_and_metadata(File.open(ARGV.first))
#   tokens.each do |t|
#     puts "#{t}"
#     puts
#   end
# end