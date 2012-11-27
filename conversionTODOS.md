# Smash Cut

Working on a way to parse a [Fountain](http://fountain.io) text file and generate a standards-compliant pdf screenplay.

Using the Ruby gem [Prawn](http://prawn.majesticseacreature.com) for the heavy lifting.

## remaining tasks

* text emphasis @done?
* dual dialog
* fix margins
* intelligent page breaks
* title page metadata
    * basics work
    * need to support multi-line key value pairs, which may be tricky considering how I've broken the file down line by line
* re-design the watermark on titlepage @done?
* revision mode -- a checkbox option to include notes and boneyards in the pdf as endnotes
    * deal with note that are MID line
* make the tokens consistent with one another, where the [0]th item is always the element ID

## known bugs

* random blank pages thrown into the pdf sometimes
* script won't successfully run sometimes?

## getting it up and running

Probably will be a simple Sinatra server on Heroku or somewhere else. Maybe a GitHub page? Maybe Amazon? Could this be ported into a Chrome App? 

Should I make this some kind of command line app that people can call system wide by just going like `smash screenplay.fountain` or something?


