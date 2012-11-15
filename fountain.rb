# Screenplays can be in any of three formats that are useful to screenwriters:
# 1. pdf
# 2. fdx
# 3. fountain
# This script will / should convert from and to any of these, using "tokens" as an intermediary step

require 'prawn'
require_relative 'fountain_helpers'

def fountain_to_tokens (fountain)
  tokens = fountain
  # ...
  return tokens
end

def html_to_tokens (html)
  tokens = html
  # ...
  return tokens
end

def fdx_to_tokens (fdx)
  tokens = fdx
  # ...
  return tokens
end

def pdf_to_tokens (pdf)
  tokens = pdf
  # ...
  return tokens
end

#####################

def tokens_to_pdf (tokens)
  pdf = tokens
  # ...
  return pdf
end

def tokens_to_html (tokens)
  html = tokens
  # ...
  return html
end

def tokens_to_fdx (tokens)
  fdx = tokens
  # ...
  return fdx
end

###########################

def fountain_to_pdf (fountain)
  # tokens = fountain_to_tokens(fountain)
  # pdf = tokens_to_pdf(tokens)
  # return pdf

  pdf = Prawn::Document.new
  pdf.text (fountain)
  return pdf

end