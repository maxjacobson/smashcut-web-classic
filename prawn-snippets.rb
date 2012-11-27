# a method i copied out of the prawn manual for understanding the margins of a page in its terms
# note: origin (0,0) is bottom left of the page

def print_coordinates
  text "top: #{bounds.top}"
  text "bottom: #{bounds.bottom}"
  text "left: #{bounds.left}"
  text "right: #{bounds.right}"
  move_down 10
  text "absolute top: #{sprintf "%.2f", bounds.absolute_top}"
  text "absolute bottom: #{sprintf "%.2f", bounds.absolute_bottom}"
  text "absolute left: #{sprintf "%.2f", bounds.absolute_left}"
  text "absolute right: #{sprintf "%.2f", bounds.absolute_right}"
end

# for adding page numbers (it stopped working, fix it later)
string = "<page>."
options = { :at => [bounds.right - 150, 745], :width => 150, :align => :right, :page_filter => lambda { |pg| pg > 1} }
number_pages string, options