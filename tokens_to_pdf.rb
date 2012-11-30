require 'prawn'
require "prawn/measurement_extensions" # lets you use inches instead of points (1/72")
require_relative 'tokens_to_pdf_helpers'

def tokens_to_prawn (tokens_and_metadata)
  timer_start = Time.now
  metadata = tokens_and_metadata[:metadata]
  tokens = tokens_and_metadata[:tokens]
  title_page = tokens_and_metadata[:title_page]
  pdf = Prawn::Document.new(:info => { :Title => metadata[:title], :Author => metadata[:author], :Creator => "smashcutapp.com"})
  pdf.font("Courier", :size => 12)

  if metadata[:has_title_page] == true
    pdf.move_cursor_to 7.29.in
    title_page[:center].each do |info|
      pdf.bounding_box([determine_center(info),pdf.cursor], :width=> 4.3.in) do
        pdf.text info
        pdf.move_down 0.175.in
      end
    end
    pdf.start_new_page
  end

  tokens.each do |token|
    if token[:element] == :slug
      if token[:has_emphasis] == true
        line = add_emphasis(token[:data])
      else
        line = token[:data]
      end
      pdf.span(5.2.in, :position => :center) do
        pdf.text line, :inline_format => true
      end
      pdf.move_down 0.175.in
    elsif token[:element] == :action
      if token[:has_emphasis] == true
        line = add_emphasis(token[:data])
      else
        line = token[:data]
      end
      pdf.span(5.2.in, :position => :center) do
        pdf.text line, :inline_format => true
      end
      pdf.move_down 0.175.in
    elsif token[:element] == :dialog_block
      token[:data].each do |chunk|
        if chunk[:element] == :character
          pdf.bounding_box([3.2.in,pdf.cursor], :width=> 4.3.in) do
            pdf.text add_emphasis(chunk[:data]), :inline_format => true
          end
        elsif chunk[:element] == :paren
          pdf.bounding_box([2.9.in,pdf.cursor], :width => 1.5.in) do
            pdf.text add_emphasis(chunk[:data]), :inline_format => true
          end
        elsif chunk[:element] == :dialog
          pdf.span(2.9.in, :position => :center) do
            pdf.text add_emphasis(chunk[:data]), :inline_format => true
          end
        end
      end
      pdf.move_down 0.175.in
    elsif token[:element] == :centered
      line = token[:data]
      line.gsub!(/(> *)|( *<)/, '')
      line = add_emphasis(line)
      pdf.bounding_box([determine_center(line),pdf.cursor], :width=> 4.3.in) do
        pdf.text line, :inline_format => true
      end
      pdf.move_down 0.175.in
    end
  end

  page_num_string = "<page>."
  page_num_options = {
    :at => [390, 740], # aka the top right. it isn't exactly perfectly positioned (TODO fix that). I wonder how it handles several-digit numbers
    :width => 150,
    :align => :right,
    :start_count_at => 2
  }
  if metadata[:has_title_page] == true
    page_num_options[:page_filter] = lambda{ |pg| pg > 2}
  else
    page_num_options[:page_filter] = lambda{ |pg| pg > 1}
  end
  pdf.number_pages page_num_string, page_num_options

  puts "Prawnified in %.2f seconds." % (Time.now - timer_start)
  return pdf
end