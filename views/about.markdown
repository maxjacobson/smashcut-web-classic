(a draft written mostly on 2012-12-20)

This might be useful to you if you are a screenwriter who has a screenplay in the [fountain](http://fountain.io) format and would like to make a pdf out of it.

This site is powered by the [smashcut](#) rubygem which I'm still working on and will soon make freely available. With the gem installed on your machine, you can do these conversions from the command line with the command `smashcut <yourscreenplay>.fountain`.

### Getting the gem

Well you can't yet, but it will be on [RubyGems.org][]. You'll just run `gem install smashcut` and you're good to go. This is also how you update to the most recent version of the gem. Run `smashcut -v` to check the version.

[RubyGems.org]: http://rubygems.org

### Feedback

If you have any feedback or would like to contribute, please feel free to reach me at:

* [max@maxjacobson.net](mailto:max@maxjacobson.net)
* [@maxjacobson](http://twitter.com/maxjacobson)
* [@smashcutapp](http://twitter.com/smashcutapp)

### Contribute

... and/or fork me on github and submit a pull request.

* [smashcut gem](#) (link forthcoming)
* [smashcutapp.com site](#) (link forthcoming)

I'd love your help. Ideally smashcut would be able to convert from and to fountain, pdf, fdx, and html in any which direction. So far it can only do from fountain to pdf or html. The *lingua franca* is an array of hashes ("tokens") which looks like this:

     [
      {:element=>:slug, :data=>"EXT. PARK - DAY"},
      {:element=>:action, :data=>"The park is quiet, empty except for a man napping with his hat over his face."},
      {:element=>:dialog_block, :data=>[{:element=>:character, :data=>"KID (O.S.)"}, {:element=>:dialog, :data=>"Don't do it."}]},
      {:element=>:dialog_block, :data=>[{:element=>:character, :data=>"OTHER KID (O.S.)"}, {:element=>:dialog, :data=>"I'm gonna."}]},
      {:element=>:action, :data=>"The kid enters the frame holding a giant water balloon."}
    ]

Hopefully that looks manageable. Smashcut should be able to convert from any format to these tokens, and then back to any format.

### Options

The default options are also the defaults for the command line command

* no filename specified. it will come up with one
* it will make a pdf
* it will exclude comments (notes, boneyards, sections, synopses)
* it will make a film screenplay

You can customize your command using the form here, or by using flags on the command line. For example:

* `smashcut example.fountain -html` is the same as checking the HTML radio
* `smashcut example.fountain -all` is the same as checking the include comments radio
* `smashcut example.fountain -tv` is the same as checking the tv radio
* `smashcut example.fountain -html -all -tv` is the same as checking all of them

If you run `smashcut example.fountain example.html` it isn't necessary to include the `-html` flag. Likewise, on the site, if you specify a filename with a `.html` ending, that takes precedence over the radio being checked to pdf.

The reason these are the defaults is that I feel like this is what I would want most often -- *just make me a pdf!* -- and I think they're pretty sensible. Let me know if some other defaults make more sense for you.

### Misc pro tips

* You can optionally specify the filename of the pdf. If you don't, smashcut will pick one for you based on the current date and time (on the web, it'll use new york time) and the screenplay title.
* also: it's not necessary to include the `.pdf` file extension, it will add that for you.
* The site is a good way to convert from fountain to pdf when on iOS and probably other mobile devices too. Maybe even on windows. I'm mainly testing on Ubuntu and OS X.

### About this site

* Written in [Ruby](http://ruby-lang.org) with the [Sinatra](http://sinatrarb.com) DSL
* Hosted by [Heroku](http://heroku.com)
* Logo by [Amber Vittoria](http://ambervittoria.com)
    * Wiggly animation done by me with help from [jQuery](http://jquery.com)
* Fonts by [Google Web Fonts](http://google.com/webfonts)
* Some of the other front end stuff in javascript, including these libraries:
    * Alerts powered by fabien-d's [Alertify.js](http://github.com/fabien-d/alertify.js)
    * With form persistence by [Garlic.js](http://garlicjs.org)
    * Buttons CSS by [Twitter Bootstrap](http://twitter.github.com/bootstrap/)

### Privacy

(Before I share the site publicly I'll make an effort to improve this situation)

I promise not to read or share your screenplay. I genuinely just want this to be useful to people. This site is a [Sinatra][]-powered web app [^sinatra], and the way Sinatra works, I'm not sure exactly how to delete the files from the Heroku server after they're sent to you. See [this thread](http://stackoverflow.com/questions/2806053/how-can-i-delete-a-file-in-sinatra-after-it-has-been-sent-via-send-file) for someone else hounding after the same question. I *think* they're stored in a temp directory and expire automatically. *I* certainly don't know how to access them. It's on my todo list to learn more about this. If this concerns you, you can still safely use the gem locally from the command line.

[Sinatra]: http://sinatra.rb
[^sinatra]: which I'll also open source for transparency
