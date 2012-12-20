## About

Smash Cut is for screenwriters to use when they have a screenplay in fountain and they want a screenplay in pdf. It's kind of like Highland except it doesn't do as much and it's available on non-Mac stuff.

It's powered by the rubygem smashcut which I'm still working on and will soon be freely available. With the gem installed on your machine, you can do these conversions from the command line with the command `smashcut <yourscreenplay>.fountain`.

### Pro Tips

* The "Include comments" checkbox can be a useful option when you're editing and want to see everything in your pdf. All it does is add `Comments: true` to your text before processing it, so feel free to include that in your metadata block and skip the checkbox.
* You can optionally specify the filename of the pdf. If you don't, smashcut will pick one for you based on the current date and time (in new york) and the screenplay title.
* also: it's not necessary to include the `.pdf` file extension, it will add that for you.
* by default, this site and gem are for making pdfs from fountain. but if you'd like an HTML file instead, just include a filename that ends in `.html`.
# The site is a good way to convert from fountain to pdf when on iOS and probably other mobile devices too

### Privacy

I promise not to read your screenplay. I genuinely just want this to be useful to people. The way the [Sinatra](http://sinatra.rb) site (which I'll also open source for transparency) works, I'm not sure exactly how to delete the files from the Heroku server after they're sent to you. See [this thread](http://stackoverflow.com/questions/2806053/how-can-i-delete-a-file-in-sinatra-after-it-has-been-sent-via-send-file) for someone else hounding after the same question. I *think* they're stored in a `/tmp` directory and expire automatically. I certainly don't know how to access them. It's on my todo list (below) to learn more about this. If this concerns you, you can still safely use the gem locally from the command line.


### TODOs and Roadmap

* Iron out the remaining bugs in the tokenizer
* Iron out the remaining bugs in the pdf generator
* Update the demo screenplay to show off all syntax elements
* Get the `Comments: true` metadata thing working
    * The checkbox on the homepage just inserts that at the top of your screenplay so you can just write that and it's like you checked the box, FYI
* Get the `Television: true` thing working
* Bundle the converter as a gem and make it work from the command line
* Share it on RubyGems and GitHub and get feedback, make improvements
* Share the site with people


