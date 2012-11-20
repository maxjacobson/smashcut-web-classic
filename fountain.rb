=begin

Screenplays can be in any of three formats that are useful to screenwriters:

1. pdf
2. fdx
3. fountain

This script will / should convert from and to any of these, using "tokens" as a generic intermediary data structure

* fountain to tokens -- not yet done
* fdx to tokens -- not yet done
* pdf to tokens -- not yet done
* tokens to pdf -- not yet done
* tokens to fdx -- not yet done
* tokens to fountain -- not yet done

I confess I'm principally interested in doing the fountain to tokens, and tokens to pdf ones.

-- Max Jacobson, 2012-11-18

=end

require 'prawn'
require_relative 'fountain_helpers'

def fountain_to_tokens (fountain)
  return fountain
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
  tokens = fountain_to_tokens(fountain)
  #puts "Tokens: #{tokens}"
  # pdf = tokens_to_pdf(tokens)
  # return pdf
  pdf = Prawn::Document.new
  pdf.text (fountain)
  return pdf
end

def fountain_to_pdf_with_comments (fountain)
  fountain = "Comments: true\n\n" + fountain
  fountain_to_pdf (fountain)
end
