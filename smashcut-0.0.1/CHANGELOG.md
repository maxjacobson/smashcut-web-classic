# CHANGELOG

## 2012-12-18

Because I should be keeping a little diary of my progress.

Today it's 2012-12-18. It's fairly late.

Last night I restructured my code into a class. Today I restructured it some more into a gem.

I added an executeable which I am very excited about.

I somehow went from 0.0.0 to 0.0.5 in my own terminology today. Ech I'll just uninstall and reset to 0.0.1 for the first night of its existence that feels right.

Before tonight I've been occasionally working on this for months I guess. It's been on the backburner. I'm sort of inspired by the newly emerged glassboard community. There are some 50 odd people who might find this useful, so I'm giving it a little more energy.

It's two in the morning. I just added some tests. Just two for now. Doesn't test much. I'm not sure how to test against the prawn object.

I'm changing the name of this project/gem from "fountain" to "smashcut" in case someone is making an official gem or something. When I want to use markdown, I install the Kramdown gem. I was thinking of names along those lines and considered Fontana. I don't know why. I'm going with smashcut for now because I like it and I have the domain smashcutapp.com.

I suppose I should initialize a git repo for this iteration of the project. OK, I did that. I'm not pushing it anywhere.

Is there any reason to use version numbers when no one besides me is using the code? I feel like there isn't. The first public release will be 0.1.0 I think. It goes Major.Minor.Patch. The first public release will be a minor milestone and I'll increment from there.

I'll have to look up how to tag specific commits with version numbers.

## 2012-12-20

I was awake for more than 25 hours and I've just slept eight. That's not too bad actually.

I restructured the smashcutapp.com site to be powered by the gem. `bundle install` is smart enough to first check if the gem is installed locally, so even though my `Gemfile` lists rubygems.org as the soruce and smashcut is not on rubygems, the app is satisfied to be running locally. But I'm not sure if Heroku feels the same way. Anyway, for that and other reasons I'm taking down the buggy demo site at <http://app.smashcutapp.com> for now and will put it back up at the top level <http://smashcutapp.com> when it's ready

I hope that won't be complicated. I'm using Heroku for the app and NearlyFreeSPeech.net for the site right now... I'll have to transfer the DNS for the TLD to Heroku, and I suppose cancel my NFS hosting.