# smashcut

Here's a gem to include fountain objects in your project.

Sample usage:

    require 'smashcut'
    text = File.open("example.fountain").read
    sp = Smashcut.new
    sp.init_with_fountain(text)
    sp.print_pdf("example.pdf")

Which will open your fountain file, interpret it, and generate a lovely screenplay-looking pdf for you.

Besides `print_pdf`, some other commands you could run on a fountain object (called, in my examples, `sp`, but you can call yours whatever) are:

* `sp.tokens_count` -- gets the total amount of tokens
* `sp.fountain_length` -- gets the total number of lines in the fountain screenplay
* `sp.get_title`
* `sp.get_title`
* `sp.get_fountain`
* `sp.get_tokens`
* `sp.get_pdf` -- returns a [prawn](http://prawn.majesticseacreature.com/) object
    * which you can `.inspect` or `.render_file("output.pdf")` for example
* `sp.title_page?` -- returns true if there exists a title page for this screenplay
* `sp.get_title_page` -- returns an array of hashes containing the data for the title page

Also included is a command line command you can call by running `smashcut example.fountain example.pdf` which does the same thing. If you don't specify the destination filename, it will make one for you that looks like this: `2012-12-18-083133pm_example.pdf` (date, time, title).

## TODOS

* make the interpreter better
* finish implementing the pdf stuff
* share on rubygems/github and get feedback
* set up smashcutapp.com as an online tool / demo
* make smashcut work with marked.app
* make the `Comments: true` work
    * on the site, change the checkbox to a radio with it set to off by default. maybe remove "comments: true" and make it a flag? consider the radios to be web replacements for the flags? I like that
* make the `Television: true` work
* update the demo screenplay to show off all syntax elements

* Make sure you're doing enough re: privacy. Random fear: under heavy load, would someone ever accidentally be sent someone else's script??
* Update the demo screenplay to show off all syntax elements
* Get the `Comments: true` metadata thing working
    * The checkbox on the homepage just inserts that at the top of your screenplay so you can just write that and it's like you checked the box, FYI
* Get the `Television: true` thing working
* Share it on RubyGems and GitHub and get feedback, make improvements
* Share the site with people

