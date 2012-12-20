module To_pdf
  def title_page_tokens_and_metadata_to_pdf(title_page, tokens, metadata)
    timer_start = Time.now
    pdf = Prawn::Document.new(
      :info => {
        :Title => self.get_title,
        :Author => self.get_author,
        :Creator => "smashcutapp.com",
        :CreationDate => Time.now
      },
      :margin => [0.5.in, 0.5.in, 0.5.in, 1.75.in] # is this a) correct? b) the best approach to dealing with this considering future problems of smart-page-breaking? also considering headers
    )
    pdf.font("Courier", :size => 12)
    if self.title_page?
      pdf = print_title_page(title_page, pdf)
    end
    tokens.each do |token|
      # my first attempt at metaprogramming. based on the element type of the token, it calls the corresponding print method
      pdf = send("print_#{token[:element].to_s}", token[:data], pdf)
    end
    puts "Prepared the pdf in #{Time.now - timer_start} seconds"
    return pdf
  end

                              ##############################
                              # some helper methods follow #
                              ##############################

  def print_title_page(data, pdf)
    # I wonder if the center box should move UP if there is too much stuff in the lower boxes...???
    if data[:center].length > 0
      pdf.move_down(4.in)
      data[:center].each do |token|
        str = emphasize(token)
        pdf.bounding_box([determine_center(str), pdf.cursor], :width=> 4.3.in) do
          pdf.text(str, :inline_format => true)
        end
      end
    end
    if data[:lower_left].length > 0
      pdf.move_cursor_to(3.in)
      data[:lower_left].each do |token|
        str = emphasize(token)
        pdf.bounding_box([0, pdf.cursor], :width => 3.in) do
          pdf.text(str, :inline_format => true)
        end
      end
    end
    if data[:lower_right].length > 0
      pdf.move_cursor_to(3.in)
      data[:lower_right].each do |token|
        str = emphasize(token)
        pdf.bounding_box([4.in, pdf.cursor], :width => 3.in) do
          pdf.text(str, :inline_format => true)
        end
      end
    end
    pdf.start_new_page
    return pdf
  end

  def print_slug(data, pdf)
    str = emphasize(data)
    pdf.text(str, :inline_format => true)
    pdf.move_down(0.175.in)
    return pdf
  end

  def print_transition(data, pdf)
    str = emphasize(data)
    pdf.text(str, :inline_format => true)
    pdf.move_down(0.175.in)
    return pdf
  end

  def print_action(data, pdf)
    str = emphasize(data)
    pdf.text(str, :inline_format => true)
    pdf.move_down(0.175.in)
    return pdf
  end

  def print_dialog_block(data, pdf)
    # thought regarding smart-page-breaking
    # consider something like this:
    # charname = data[0][:data]
    # bc we might need to know the char's name for this block, if we need to repeat it on the next page
    data.each do |subtoken|
      if subtoken[:element] == :character
        pdf.bounding_box([2.5.in, pdf.cursor], :width => 5.3.in) do # none of these numbers are cool
           pdf.text(emphasize(subtoken[:data]), :inline_format => true)
         end
      elsif subtoken[:element] == :paren
        pdf.span(1.5.in, :position => :center) do
          pdf.text(emphasize(subtoken[:data]), :inline_format => true)
        end
      elsif subtoken[:element] == :dialog
        pdf.span(2.9.in, :position => :center) do
          pdf.text(emphasize(subtoken[:data]), :inline_format => true)
        end
      end
    end
    pdf.move_down(0.175.in)
    return pdf
  end

  def print_dual_dialog_block(data, pdf)
    # p data #=> nil for some reason???
    # data.each do |token|
    #   pdf.text(token[:data])
    #   pdf.move_down(0.175.in)
    # end
    return pdf
  end

  def print_pagebreak(data, pdf)
    # str = emphasize(data)
    # pdf.text(str, :inline_format => true)
    # pdf.move_down(0.175.in)
    pdf.start_new_page
    return pdf
  end

  def print_centered(data, pdf)
    str = emphasize(data)
    pdf.bounding_box([determine_center(str), pdf.cursor], :width=> 4.3.in) do
      pdf.text(str, :inline_format => true)
    end
    pdf.move_down(0.175.in)
    return pdf
  end

  def print_section(data, pdf)
    str = emphasize(data)
    pdf.text(str, :inline_format => true)
    pdf.move_down(0.175.in)
    return pdf
  end

  def print_single_line_note(data, pdf)
    if self.verbose?
      str = emphasize(data)
      str = add_color(str)
      pdf.text(emphasize(data), :inline_format => true)
      pdf.move_down(0.175.in)
    end
    return pdf
  end

  def print_boneyard(data, pdf)
    if self.verbose?
      str = emphasize(data)
      str = add_color(str)
      pdf.text(str, :inline_format => true)
      pdf.move_down(0.175.in)
    end
    return pdf
  end

  def print_synopsis(data, pdf)
    if self.verbose?
      str = emphasize(data)
      str = add_color(str)
      pdf.text(str, :inline_format => true)
      pdf.move_down(0.175.in)
    end
    return pdf
  end

  def print_extracted_note(data, pdf)
    if self.verbose?
      str = emphasize(data)
      str = add_color(str)
      pdf.text(str, :inline_format => true)
      pdf.move_down(0.175.in)
    end
    return pdf
  end

  def emphasize (data)
    ### these should be gsubs right? they will only match the first instance
    # i am changing these to gsubs but dont feel like testing them right now
    emph = /(_|\*{1,3}|_\*{1,3}|\*{1,3}_)(.+)(_|\*{1,3}|_\*{1,3}|\*{1,3}_)/
    biu = /(_{1}\*{3}(?=.+\*{3}_{1})|\*{3}_{1}(?=.+_{1}\*{3}))(.+?)(\*{3}_{1}|_{1}\*{3})/
    bu = /(_{1}\*{2}(?=.+\*{2}_{1})|\*{2}_{1}(?=.+_{1}\*{2}))(.+?)(\*{2}_{1}|_{1}\*{2})/
    iu = /(?:_{1}\*{1}(?=.+\*{1}_{1})|\*{1}_{1}(?=.+_{1}\*{1}))(.+?)(\*{1}_{1}|_{1}\*{1})/
    bi = /(\*{3}(?=.+\*{3}))(.+?)(\*{3})/
    b = /(\*{2}(?=.+\*{2}))(.+?)(\*{2})/
    i = /(\*{1}(?=.+\*{1}))(.+?)(\*{1})/
    u = /(_{1}(?=.+_{1}))(.+?)(_{1})/
    str = data.dup
    str.gsub!(biu, '<b><i><u>\2</u></i></b>')
    str.gsub!(bu, '<b><u>\2</u></b>')
    str.gsub!(iu, '<i><u>\2</u></i>')
    str.gsub!(bi, '<b><i>\2</i></b>')
    str.gsub!(b, '<b>\2</b>')
    str.gsub!(i, '<i>\2</i>')
    str.gsub!(u, '<u>\2</u>')
    return str
  end

  def add_color(data)
    return "<color rgb=\"FF1905\">#{data}</color>"
  end

  def determine_center (line)
    i = 252 - (288/85) * line.length
    return i - 100 # because it looked bad
    # return (((85 - line.length) / 2) * 6.776470588) - 36
    # 85 = how many characters go fully across the page
    # 36 = the default margin in prawn
    # 6.776470588 = 576/85, aka the width of a single character
    # afaik prawn doesn't support centering of text
    ##### I've since learned it does, and I use it elsewhere in this script (search `:center`). is this method still necessary?
    # i think this will center it nicely. what it returns will be used as a left margin
  end
end