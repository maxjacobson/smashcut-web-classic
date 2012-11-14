# copy.md (May 2012)

## Smash Cut

Is a revolutionary new app for screenwriters.

Write using the [Fountain](http://fountain.io) syntax.

Save your files as `Your great screenplay.fountain` instead of `Your boring screenplay.fdx`.

Freedom to edit in any text editor...

* on your phone or tablet
* on your friends or family's computers
* at the library

But we think you'll want to use Smash Cut.

Coming soon to the Mac App Store.

# README.md (2012-10-12)

# smash cut app

## to dos

* Write a privacy policy that basically says we wont read or keep any screenplays.
    * mention that this being cross platform means it'll work on more platforms than highland?
    * say we want to be the simplest, easiest tool
* Add an FAQ and a sample script.
* EC2 or Heroku?
* Sinatra

## margins info

### from simplyscripts.com

<http://www.simplyscripts.com/WR_format.html>

Stage directions and shot headings (slug lines) have a margin of 1.7" of the left and 1.1" on the right. two blank lines precede each shot heading.

scene/shot numbers. the left number is placed 1.0" from the left edge of the page and the right scene number is placed 7.4" from the left margin of the page

bottom page margin is at least .5" (or three single lines) following the (CONTINUED) at the end of a scene

(thought: are we an "opinionated" web app? do we deliberately not support continueds?)

continued's are used when a shot or scene carries over from one page to the next.

At the bottom put `\n\n(CONTINUED)` and at the top of the next put `CONTINUED:\n\n`

when breaking action lines across two pages, don't split mid-sentence. intelligently break the page only between sentences. Same for dialog.

further: if there is a parenthetical, that should always be glued to a character name. the example they gave goes:

    SKYLAR
    See, it's my life story.
    (MORE)
    ----page break----
    SKYLAR (CONT'D)
    (parenthetical goes here)
    Five more minutes...

So like... OK.

(IDEA: should there be options for whether to include mores and continueds? and other options? or should the opinionated thing mean I just do it my way, buddy)

If you put a slugline, that shouldn't be immediately followed by a page break... if a slug needs to appear at the end of a page, just push it to the next page.o

transitions should be preceded by one blank line and followed by two blank lines. don't start a new page with a scene transition

### converting inches to points in prawn

One point in prawn is 1/72". So, for example, a character name should have a left margin of 3.7", and therefore 3.7*72 points...? aka 266.4. maybe we'll just call that 266

## bookmarks

* [this](http://stackoverflow.com/questions/742271/generating-pdf-files-with-javascript) makes it seems pretty clear that it will be much easier to work with the data on a server and for my needs basically impossible.
* <http://code.google.com/p/jspdf/>
* <http://andreasgal.com/2011/06/15/pdf-js/>
* <http://badassjs.com/post/708922912/pdf-js-create-pdfs-in-javascript>
* [Fountain.js](https://github.com/mattdaly/Fountain.js)
* [pdf.js](https://github.com/mozilla/pdf.js)
* [pdfkit](http://pdfkit.org)

# faq.md (2012-10-13)

>What is Smash Cut?

We aim to be the fastest and easiest way to convert your screenplay from text to pdf.

>What's Fountain?

[Fountain](http://fountain.io) is a cool-ass syntax you should be writing your screenplays in. It's really easy and flexible. It looks like this:

>What app should I use to write in?

Any plaintext editor. There are a lot of really great ones. I recommend:

### On Mac OS X

* TextEdit (already on your Mac)
* [iA Writer](http://www.iawriter.com)
* [TextMate 2](https://github.com/textmate/textmate/downloads)
* [MacVim or Vim](http://www.vim.org) -- [(syntax plugin)](http://www.vim.org/scripts/script.php?script_id=3880)
* [Byword](http://bywordapp.com)
* [Sublime Text 2](http://www.sublimetext.com/2)
* TextWrangler -- (syntax plugin)
* BBEdit
* WriteRoom
* Chocolat

### On iOS
### On Windows

Probably don't use the built-in notepad app. It has some weird shit.

* Notepad++ (free)
* gvim

### On Linux

* gedit (already there probably)
* Sublime Text 2
* vim or gvim
* [UberWriter](http://uberwriter.wolfvollprecht.de)

>Will this come to any other platforms?

Poss.

>Who did your art?

[Amber Vittoria](http://ambervittoria.com) did it.

>What does it mean?

What do you think it means?