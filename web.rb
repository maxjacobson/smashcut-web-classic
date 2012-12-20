require 'sinatra'
require 'kramdown'
require 'sass'
require 'prawn'
require 'smashcut'

enable :sessions

# set :dump_errors, false
# set :show_exceptions, false

# not_found do
#   @title= "Smash Cut"
#   @subtitle = "404"
#   erb :'404'
# end

# error do
#   @title= "Smash Cut"
#   @subtitle = "500"
#   erb :'500'
# end

get '/' do
  markdown :temp, :layout => false
  # @title = 'Smash Cut'
  # @subtitle = 'For your fountain screenplays'
  # erb :home
end

# get '/css/style.css' do
#   scss :style
# end

# get '/about' do
#   @title = "Smash Cut"
#   @subtitle = "About"
#   erb :about
# end

# post '/render' do
#   if params[:comments] == "true"
#     text = "Comments: true\n#{params[:fountain]}"
#   else
#     text = params[:fountain]
#   end

#   screenplay = Smashcut.new
#   screenplay.init_with_fountain(text)
#   if params[:filename] == ""
#     screenplay.print_pdf
#   elsif params[:filename] =~ /.html$/
#     screenplay.print_html(params[:filename])
#     filename = screenplay.get_html_filename
#     send_file(filename, :type => :html, :filename => filename)
#   else
#     screenplay.print_pdf(params[:filename])
#     filename = screenplay.get_pdf_filename
#     send_file(filename, :type => :pdf, :filename => filename)
#   end
# end
