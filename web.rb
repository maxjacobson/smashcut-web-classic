require 'sinatra'
require 'kramdown'
require 'sass'
require 'prawn'
# require 'smashcut'

enable :sessions

# set :dump_errors, false
# set :show_exceptions, false

not_found do
  @title= "Smash Cut"
  @subtitle = "404"
  erb :'404'
end

error do
  @title= "Smash Cut"
  @subtitle = "500"
  erb :'500'
end

get '/' do
  @title = 'Smash Cut'
  @subtitle = 'For your Fountain screenplays'
  erb :home
end

get '/*.md' do # the heck is this waste of time for?
  splat = params[:splat][0]
  path = "/views/#{splat}.markdown"
  if File.exists?(path)
    puts "exists"
    erb "<pre><code>#{File.open(path).read}</code></pre>"
  else
    erb :'404'
  end
end

# deprecating this because it's kind of slow having to compile on every single page load...
# even if it is damn convenient
# run this instead if you're gonna be editing the sass:
# sass --watch views/style.scss:public/css/style.css
#
# get '/css/style.css' do
#   scss :style
# end

get '/about' do
  @title = "Smash Cut"
  @subtitle = "About"
  erb :about
end

get '/changelog' do
  @title = "Smash Cut"
  @subtitle = "Changelog"
  erb :changelog
end

get '/forget' do
  session.clear
  redirect '/'
end

post '/render' do
  text = params[:fountain]
  options = {:from => :fountain, :comments => params[:comments].to_sym, :medium => params[:medium].to_sym}
  p options
  screenplay = Smashcut.new
  screenplay.init(text, options)

  file_format_radio = params[:file_format].to_sym
  file_format_textarea = params[:filename].match(/(\.html$)|(\.pdf$)|(\.fdx$)/).to_s.sub(/^\./, '').to_sym
  if params[:filename] == "" or [:pdf, :html].include?(file_format_textarea) == false
    # if you didn't specify a filename
      # or you did, but you didn't include a file extension
        # or you did, but not one we yet support
    # we'll listen to the radio
    to = file_format_radio
  else
    # if you *did* include a file extension in the text area
    if file_format_radio == file_format_textarea
      # we're all in agreement here
      to = file_format_radio
    else
      # the textarea and radio disagree, so the textarea takes precedence
      to = file_format_textarea
    end
  end

  session[:screenplays] = Array.new if session[:screenplays].nil?
  session[:screenplays].push({:author => screenplay.get_author, :title => screenplay.get_title})
  session[:screenplays].uniq!
  if to == :pdf
    screenplay.print_pdf(params[:filename])
    to_filename = screenplay.get_pdf_filename
    send_file(to_filename, :type => :pdf, :filename => to_filename)
  elsif to == :html
    screenplay.print_html(params[:filename])
    to_filename = screenplay.get_html_filename
    send_file(to_filename, :type => :html, :filename => to_filename)
  end

  redirect '/'
end
