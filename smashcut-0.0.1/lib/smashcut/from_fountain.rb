module From_fountain
  def fountain_to_title_page_tokens_and_metadata(screenplay)
    timer_start = Time.now
    the_time = Time.now

    tokens = Array.new # what the screenplay will become
    metadata = Hash.new # what the metadata will become
    metadata[:include_comments] = false # defaults to false
    title_page = {:center => Array.new, :lower_left => Array.new, :lower_right => Array.new}

    regex = Hash.new # the patterns for all these elements will be stored in here
    regex[:character] = /^([A-Z ().'0-9\^]+)+$/
    regex[:slug] = /^((?:\*{0,3}_?)?(?:(?:int|ext|est|i\/e)[. ]).+)|^(?:\.(?!\.+))(.+)/i
    regex[:paren] = /^(\(.+\))$/
    # regex[:centered] = /^(?:> *)(.+)(?: *<)(\n.+)*/
    regex[:centered] = /^ *> *.+ *< *$/
    regex[:transition] = /^((?:FADE (?:TO BLACK|OUT)|CUT TO BLACK|FADE IN)\.|.+ TO\:)|^(?:> *)(.+)/
    regex[:emphasis] = /(_|\*{1,3}|_\*{1,3}|\*{1,3}_)(.+)(_|\*{1,3}|_\*{1,3}|\*{1,3}_)/
    regex[:all_notes] = /(?:\[{2}(?!\[+))(.+)(?:\]{2}(?!\[+))/
    regex[:single_line_note] = /^(?:\[{2}(?!\[+))(.+)(?:\]{2}(?!\[+))$/
    regex[:boneyard_begin] = /^\/\*$/
    regex[:boneyard_end] = /^\*\/$/
    regex[:pagebreak] = /^\={3,}$/
    regex[:title_page] = /^((?:title|credit|author[s]?|source|notes|draft date|date|contact|copyright)\:)/im
    regex[:comments_true] = /^comments\: true/im
    regex[:television_true] = /^television\: true/im
    regex[:section] = /^(#+)(?: *)(.*)/
    regex[:synopsis] = /^(?:\=(?!\=+) *)(.*)/

    # split screenplay line by line into an array of strings
    lines = screenplay.split(/\n/)

    # some quick cleanup
    for i in 0...lines.length
      lines[i].gsub!(/\r/, '')
      # lines[i].gsub!(/  /, ' ') # double spaces to single #does this screw up the titlepage 3spacetab shit? probably
      # another flaw in that (that really needs to be improved) is that if you do it like this:
      # notes:
      #     note 1
      #     note 2
      # then that counts as THREE notes because the first blank line (one space, really) is being counted where it shouldn't be
    end

    # match lines and populate the tokens array with informative hashes
    i = 0
    while i < lines.length
      extracted_note = nil # is this necessary? maybe not on first loop?

      if lines[i] =~ regex[:all_notes]
        if lines[i] =~ regex[:single_line_note]
          temp_note_text = lines[i]
          temp_note_text.gsub!(/\[\[/,'')
          temp_note_text.gsub!(/\]\]/,'')
          tokens.push({:element => :single_line_note, :data => temp_note_text})
          i+=1
          break if i == lines.length
        else
          extracted_note = lines[i].match(regex[:all_notes])[1]
          lines[i].gsub!(regex[:all_notes], '')
          lines[i].gsub!(/ *$/, '') # trailing whitespace
          lines[i].gsub!(/  /, ' ') # double spaces to single spaces
        end
      end

      # puts "Looking at: #{lines[i]}"
      if lines[i] == ""
        # if the line is blank, just skip on over it
      elsif lines[i] =~ regex[:slug]
        tokens.push({:element => :slug, :data => lines[i]})
      elsif lines[i] =~ regex[:title_page]
        if lines[i] =~ /title/im
          temp_text = lines[i].gsub(/title: */im, '')
          in_block = true
          while in_block == true
            if lines[i+1] =~ /\t/ or lines[i+1] =~ /   /
              temp_text << "\n" + lines[i+1]
              i += 1
            else
              in_block = false
            end
          end
          metadata[:title] = temp_text
          title_page[:center].push(temp_text)
        elsif lines[i] =~ /credit/im
          temp_text = lines[i].gsub(/credit: */im, '')
          in_block = true
          while in_block == true
            if lines[i+1] =~ /\t/ or lines[i+1] =~ /   /
              temp_text << "\n" + lines[i+1]
              i += 1
            else
              in_block = false
            end
          end
          metadata[:credit] = temp_text
          title_page[:center].push(temp_text)
        elsif lines[i] =~ /author/im
          temp_text = lines[i].gsub(/author: */im, '')
          in_block = true
          while in_block == true
            if lines[i+1] =~ /\t/ or lines[i+1] =~ /   /
              temp_text << "\n" + lines[i+1]
              i += 1
            else
              in_block = false
            end
          end
          metadata[:author] = temp_text
          title_page[:center].push(temp_text)
        elsif lines[i] =~ /authors/im
          temp_text = lines[i].gsub(/authors: */im, '')
          in_block = true
          while in_block == true
            if lines[i+1] =~ /\t/ or lines[i+1] =~ /   /
              temp_text << "\n" + lines[i+1]
              i += 1
            else
              in_block = false
            end
          end
          metadata[:authors] = temp_text
          title_page[:center].push(temp_text)
        elsif lines[i] =~ /source/im
          temp_text = lines[i].gsub(/source: */im, '')
          in_block = true
          while in_block == true
            if lines[i+1] =~ /\t/ or lines[i+1] =~ /   /
              temp_text << "\n" + lines[i+1]
              i += 1
            else
              in_block = false
            end
          end
          metadata[:source] = temp_text
          title_page[:lower_left].push(temp_text)
        elsif lines[i] =~ /notes/im
          temp_text = lines[i].gsub(/notes: */im, '')
          in_block = true
          while in_block == true
            if lines[i+1] =~ /\t/ or lines[i+1] =~ /   /
              temp_text << "\n" + lines[i+1]
              i += 1
            else
              in_block = false
            end
          end
          metadata[:notes] = temp_text
          title_page[:lower_right].push(temp_text)
        elsif lines[i] =~ /draft date/im
          temp_text = lines[i].gsub(/draft date: */im, '')
          in_block = true
          while in_block == true
            if lines[i+1] =~ /\t/ or lines[i+1] =~ /   /
              temp_text << "\n" + lines[i+1]
              i += 1
            else
              in_block = false
            end
          end
          metadata[:draft_date] = temp_text
          title_page[:lower_left].push(temp_text)
        elsif lines[i] =~ /date/im
          temp_text = lines[i].gsub(/date: */im, '')
          in_block = true
          while in_block == true
            if lines[i+1] =~ /\t/ or lines[i+1] =~ /   /
              temp_text << "\n" + lines[i+1]
              i += 1
            else
              in_block = false
            end
          end
          metadata[:date] = temp_text
          title_page[:lower_left].push(temp_text)
        elsif lines[i] =~ /contact/im
          temp_text = lines[i].gsub(/contact: */im, '')
          in_block = true
          while in_block == true
            if lines[i+1] =~ /\t/ or lines[i+1] =~ /   /
              temp_text << "\n" + lines[i+1]
              i += 1
            else
              in_block = false
            end
          end
          metadata[:contact] = temp_text
          title_page[:lower_left].push(temp_text)
        elsif lines[i] =~ /copyright/im
          temp_text = lines[i].gsub(/copyright: */im, '')
          in_block = true
          while in_block == true
            if lines[i+1] =~ /\t/ or lines[i+1] =~ /   /
              temp_text << "\n" + lines[i+1]
              i += 1
            else
              in_block = false
            end
          end
          metadata[:copyright] = temp_text
          title_page[:lower_left].push(temp_text)
        end
      elsif lines[i] =~ regex[:comments_true]
        metadata[:include_comments] = true
      elsif lines[i] =~ regex[:television_true]
        metadata[:television] = true
      elsif lines[i] =~ regex[:centered]
        # remove the ><
        temp_centered_text = lines[i].gsub(/(> *)|( *<)/, '')
        # and push
        tokens.push({:element => :centered, :data => temp_centered_text})
      elsif lines[i] =~ /[A-Z]/ and lines[i] =~ /[a-z]/
        # matches capital letters and lower case letters
        # AFTER checking slug and transition
        # means action... right?
        tokens.push({:element => :action, :data => lines[i]})
      elsif lines[i] =~ regex[:pagebreak]
        tokens.push({:element => :pagebreak, :data => ""})
      elsif lines[i] =~ regex[:section]
        tokens.push({:element => :section, :data => lines[i]})
      elsif lines[i] =~ regex[:synopsis]
        the_synopsis = lines[i]
        the_synopsis.gsub!(/ *= /,'')
        tokens.push({:element => :synopsis, :data => the_synopsis})
      elsif lines[i] =~ regex[:boneyard_begin]
        temp_boneyard_block = String.new
        in_boneyard_block = true
        while in_boneyard_block == true
          i += 1
          if lines[i] =~ regex[:boneyard_end]
            in_boneyard_block = false
          else
            temp_boneyard_block << lines[i] + "\n"
          end
        end
        tokens.push({:element => :boneyard, :data => temp_boneyard_block})
      elsif lines[i] =~ regex[:character] and lines[i-1] == "" and lines[i+1] != ""
        temp_dialog_block = Array.new
        in_dialog_block = true
        is_dual_dialog = false
        the_char = lines[i]
        if lines[i] =~ / *\^$/
          is_dual_dialog = true
          the_char.gsub!(/ *\^$/, '')
        end
        temp_dialog_block.push({:element => :character, :data => the_char})
        while in_dialog_block == true
          i += 1
          if lines[i] == ""
            in_dialog_block = false
          else
            if lines[i] =~ regex[:paren]
              temp_dialog_block.push({:element => :paren, :data => lines[i]})
            else
              temp_dialog_block.push({:element => :dialog, :data => lines[i]})
            end
          end
        end
        tokens.push({:element => :dialog_block, :data => temp_dialog_block})
        if is_dual_dialog == true
          second_speaker = tokens.pop
          first_speaker = tokens.pop
          tokens.push({:element => :dual_dialog_block, :first_speaker => first_speaker, :second_speaker => second_speaker})
        end
      elsif lines[i] =~ regex[:transition]
        tokens.push({:element => :transition, :data => lines[i]})
      else
        tokens.push({:element => :action, :data => lines[i]})
      end

      if extracted_note != nil
        tokens.push({:element => :extracted_note, :data => extracted_note})
      end


      i += 1
      if (Time.now - the_time) > 0.5
        puts "An unsually long time (#{Time.now - the_time} seconds) was spent on the following:\n#{tokens[-1]}"
      end
      the_time = Time.now
    end

    # checks if there's gonna be a title page
    # this is used by prawn to determine whether to make a title page
    # and also when to begin counting page numbers
    if title_page[:center].length > 0 or title_page[:lower_left].length > 0 or title_page[:lower_right].length > 0
      metadata[:has_title_page] = true
    else
      metadata[:has_title_page] = false
    end

    # how'd we do?
    puts "Tokenized in #{Time.now - timer_start} seconds"
    return title_page, tokens, metadata
  end
end