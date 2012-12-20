# TODO add an metadata element "logo" or "image" and let people provide a path to the file
# if the file is online, download the file, embed it, and then delete the file
# do a file.exists? on the filename and if not, check if it matches /^http/ or whatever
# maybe add a markdown-like image reference so they can control more specifically where the image shows up

require 'prawn'
require 'prawn/measurement_extensions'
require_relative 'smashcut/from_fountain'
require_relative 'smashcut/to_pdf'
require_relative 'smashcut/to_html'

class Smashcut
  include From_fountain
  include To_pdf
  include To_html

  def init(fountain, options)
    @fountain = fountain
    # not currently doing anything with options...
    #=> {:from=>:fountain, :comments=>:include, :medium=>:tv}
    # another thing: consider... other methods definitely accept options this way but they don't always include the curly braces... am I doing this in a normal-ish way?
    @title_page, @tokens, @metadata = fountain_to_title_page_tokens_and_metadata(fountain)
  end

=begin
  def init_with_fdx(fdx)
    hypothetically, you could send in some XML and it would be able to interpret it. why not?
  end
  def init_with_pdf(pdf)
    even more hypothetically, it could "melt down" pdfs into tokens/fountain/fdx
  end
  def init_with_html(html)
    likewise...
  end
=end

  def find_unused_filename (filename)
    puts "#{filename} exists"
    filename_regex = /^(.+)(.)(pdf|html|fdx|fountain)$/
    naked = filename.match(filename_regex)[1]
    ending = filename.match(filename_regex)[2] + filename.match(filename_regex)[3]
    i = 1
    while File.exists?("#{naked} (#{i-1})#{ending}") == true or filename == "#{naked}#{ending}"
      filename = "#{naked} (#{i})#{ending}"
      i += 1
    end
    puts "new filename: #{filename}"
    return filename
  end

  def print_pdf(*name)
    if @pdf.nil?
      @pdf = title_page_tokens_and_metadata_to_pdf(@title_page, @tokens, @metadata)
    end
    # you can optionally specify the filename for the pdf
    timer_start = Time.now
    # name.length == 0 ? filename = "#{Time.now.strftime("%Y-%m-%d-%I%M%P")}_#{self.get_title.downcase}.pdf".gsub!(/ /, '_') : filename = "#{name[0]}.pdf" if name[0] !~ /.pdf/
    if name.length == 0 or name[0] == ""
      filename = "#{Time.now.strftime("%Y-%m-%d-%I%M%S%P")}_#{self.get_title.downcase}.pdf".gsub(/ /, '_')
    else
      filename = name[0]
      filename = "#{filename}.pdf" if filename !~ /.pdf/
    end
    filename = find_unused_filename(filename) if File.exists?(filename)
    @pdf_filename = filename
    @pdf.render_file(filename)
    puts "Printed to #{filename} in #{Time.now - timer_start} seconds"
  end

  def print_html(*name)
    if @html.nil?
      @html = title_page_tokens_and_metadata_to_html(@title_page, @tokens, @metadata)
    end
    timer_start = Time.now
    if name.length == 0 or name[0] == ""
      filename = "#{Time.now.strftime("%Y-%m-%d-%I%M%S%P")}_#{self.get_title.downcase}.html".gsub(/ /, '_')
    else
      filename = name[0]
      filename = "#{filename}.html" if filename !~ /.html/
    end

    filename = find_unused_filename(filename) if File.exists?(filename)

    File.open(filename, "w") do |f|
      f.write(@html)
    end
    @html_filename = filename
    puts "Printed to #{filename} in #{Time.now - timer_start} seconds"
  end

  def tokens_count
    timer_start = Time.now
    count = 0
    @tokens.each do |token|
      if token[:data].class == Array
        count += token[:data].length
      else
        count += 1
      end
    end
    puts "Counted the tokens in #{Time.now - timer_start} seconds"
    return count
  end

  def fountain_length
    lines = @fountain.split("\n")
    lines.delete_if {|x| x == ""}
    return lines.length
  end

  def get_title
    @metadata[:title].nil? ? "My Great Screenplay" : @metadata[:title]
  end

  def get_author
    @metadata[:author].nil? ? "My Great Name" : @metadata[:author]
  end

  def get_fountain
    return @fountain
  end

  def get_tokens
    return @tokens
  end

  def get_metadata
    return @metadata
  end

  def get_pdf
    if @pdf.nil?
      @pdf = title_page_tokens_and_metadata_to_pdf(@title_page, @tokens, @metadata)
    end
    return @pdf
  end

  def get_html
    if @html.nil?
      @html = title_page_tokens_and_metadata_to_html(@title_page, @tokens, @metadata)
    end
    return @html
  end

  def get_title_page
    return @title_page
  end

  def get_title_page_center
    return @title_page[:center]
  end

  def get_title_page_lower_left
    return @title_page[:lower_left]
  end

  def get_title_page_lower_right
    return @title_page[:lower_right]
  end

  def title_page?
    @metadata[:has_title_page] ? true : false
  end

  def verbose?
    @metadata[:include_comments] ? true : false
  end

  def get_pdf_filename
    return @pdf_filename
  end

  def get_html_filename
    return @html_filename
  end

end

