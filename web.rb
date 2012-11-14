require 'sinatra'
require 'kramdown'

enable :sessions
set :dump_errors, false
set :show_exceptions, false

def cap_first (s)
  # this code via stack overflow http://stackoverflow.com/questions/2646709/capitalize-only-first-character-of-string-and-leave-others-alone-rails
  return s.slice(0,1).capitalize + s.slice(1..-1)
end

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

post '/render' do
  @title = "Smash Cut"
  @subtitle = "Your PDF, rendered (coming soon)"

  txt = params[:fountain]
  txt.gsub!(/\n/, '<br />')
  txt = "<hr />\n" + txt

  @fountain_text = txt
  erb :pdf
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
