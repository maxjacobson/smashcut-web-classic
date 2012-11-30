require 'sinatra'
require 'kramdown'
require 'sass'
require 'prawn'
require_relative 'fountain_to_tokens_and_metadata'
require_relative 'tokens_to_pdf'

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

  # send the fountain screenplay, get a hash back
  # the hash will have the title and the pdf in it

  if params[:comments] == "true"
    screenplay = "Comments: true\n" + params[:fountain]
  else
    screenplay = params[:fountain]
  end

  tokens_and_metadata = tokenize(screenplay)
  pdf = tokens_to_prawn(tokens_and_metadata)

  # get the movie title
  metadata = tokens_and_metadata[:metadata]
  if metadata[:title].nil?
    movie_title = " my great screenplay"
  else
    movie_title = " " + metadata[:title].downcase
  end
  # hyphenate it, including the leading space we just gave it
  movie_title.gsub!(/ /, '-')

  file_name = Time.now.strftime("%Y-%m-%d-%I%M%P") + movie_title + ".pdf"
  pdf.render_file(file_name)
  send_file file_name, :type => :pdf, :filename => file_name

  redirect '/'
end