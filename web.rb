require 'sinatra'
require 'kramdown'
require 'sass'
require 'prawn'
require_relative 'helpers'
require_relative 'fountain'
require_relative 'fountain_helpers'

enable :sessions

set :dump_errors, false
set :show_exceptions, false

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
  @title = "Smash Cut"
  @subtitle = "For your fountain screenplays"
  erb :home
end

get '/css/style.css' do
  scss :style
end

get '/faq' do
  @title = "Smash Cut"
  @subtitle = "FAQs"
  erb :faq
end

post '/render' do
  if params[:comments] == "true"
    pdf = fountain_to_pdf_with_comments (params[:fountain])
  else
    pdf = fountain_to_pdf (params[:fountain])
  end

  if @movie_title.nil?
    @movie_title = ""
  else
    @movie_title = "-" + @movie_title
  end
  
  file_name = Time.now.strftime("%Y-%m-%d-%I%M%P") + @movie_title + ".pdf"
  pdf.render_file (file_name)
  send_file file_name, :type => :pdf, :filename => file_name
  redirect '/'
end

get '/:page' do
  if File.exists?('views/'+params[:page]+'.erb')
    @title = "Smash Cut"
    @subtitle = cap_first(params[:page].to_s)
    erb params[:page].to_sym
  else
    @error_page = params[:page]
    raise error(404)
  end
end
