# smashcut

This is web app powered by `fountain.rb` which I'm developing concurrently.

## fountain.rb

This will be a ruby port of Matt Daly's `fountain.js` with some added functionality, most importantly the ability to convert from fountain to pdf.

The pdf generation will be powered by prawn

fountain.rb will be bundled as a gem and shared on rubygems and github.

it will have several functions within it:

* fountain-to-tokens
* tokens-to-pdf
* tokens-to-html

that's all I'm particularly interested in making but I'll lay the groundwork for others to write:

* tokens-to-fdx
* fdx-to-tokens
* html-to-tokens
* pdf-to-tokens

From the command line, the default is to generate a pdf from a fountain file. You'll be able to use flags to make it do other things, or just call the methods from within your app.
