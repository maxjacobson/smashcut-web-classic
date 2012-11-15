require 'sinatra'
require 'kramdown'
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

get '/faq' do
  @title = "Smash Cut"
  @subtitle = "FAQs"
  erb :faq
end

post '/render.pdf' do
  # @title = "Smash Cut"
  # @subtitle = "Your PDF, rendered (coming soon)"
  # @fountain_text = text_to_html(params[:fountain])
  # erb :pdf

  content_type 'application/pdf'
  pdf = fountain_to_pdf (params[:fountain])
  pdf.render_file('output.pdf')
  File.read('output.pdf')

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
