require 'prawn'
require "prawn/measurement_extensions" # lets you use inches instead of points (1/72")

def tokens_to_prawn (tokens_and_metadata)
  timer_start = Time.now
  metadata = tokens_and_metadata[:metadata]
  tokens = tokens_and_metadata[:tokens]
  pdf = Prawn::Document.new(:info => { :Title => metadata[:title], :Author => metadata[:author], :Creator => "smashcutapp.com"})
  pdf.font("Courier", :size => 12)
  tokens.each do |chunk|
    pdf.text chunk.to_s
  end
  
  page_num_string = "<page>."
  page_num_options = {
    :at => [390, 740], # aka the top right. it isn't exactly perfectly positioned (TODO fix that). I wonder how it handles several-digit numbers
    :width => 150,
    :align => :right,
    :start_count_at => 2
  }
  if metadata[:there_is_a_title_page] == true
    page_num_options[:page_filter] = lambda{ |pg| pg > 2}
  else
    page_num_options[:page_filter] = lambda{ |pg| pg > 1}
  end
  pdf.number_pages page_num_string, page_num_options
  
  puts "Prawnified in %.2f seconds." % (Time.now - timer_start)
  return pdf
end