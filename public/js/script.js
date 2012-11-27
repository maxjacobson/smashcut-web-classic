$(document).ready(function(){

  //initial logo animation
  var animateInit = $(window).width();
  animateInit -= 300;
  animateInit /= 2;
  var oldWidth = $(window).width(),
    newWidth, diff;
  $('#logo').animate({
    opacity: 1,
    left: '+=' + animateInit + 'px'
  }, 500, function() {});

  //animation on window resize
  $(window).resize(function() {
    console.log("Container width: " + $('#container').width());
    newWidth = $(window).width();
    if(newWidth < oldWidth) {
      diff = oldWidth - newWidth;
      diff /= 2;
      $('#logo').animate({
        opacity: 1,
        left: '-=' + diff + 'px'
      }, 50, function() {});
    } else {
      diff = newWidth - oldWidth;
      diff /= 2;
      $('#logo').animate({
        opacity: 1,
        left: '+=' + diff + 'px'
      }, 50, function() {});
    }
    oldWidth = newWidth;
  });

  // add demo text to fountain box
  $("#demo").click(function() {
    $("#fountain").val("Title: My Great Screenplay\nCredit: Written by\nAuthor: Your Name Here\n\nFADE IN:\n\nINT. YOUR OFFICE - DAY\n\nYou sit in the break room. It's your lunch break. You've got your moleskin and your four dollar pen.\n\nYOU\nToday I will write my great screenplay.\n\nANNOYING GEORGE\nHey, how was your weekend?\n\nYOU\n(angrily)\n**Not now** George!\n\nANNOYING GEORGE\nSorry...\n\nHe SHUFFLES off.\n\n[[Note to self: maybe I shouldn't use his real name...?]]\n\nFADE TO:\n\nEXT. UNDER A BRIDGE - NIGHT\n\nTwo cigarette embers _burn_ in the darkness.\n\nGRUFF VOICE\nYou got the goods?\n\nYOU\nI got it...\n\nYour silhouette hands his silhouette... _**A SELF-ADDRESSED-STAMPED ENVELOPE**_.\n\nGRUFF VOICE\nCan't wait to read it and give some constructive feedback.\n\nYOU\nThanks.\n\nGRUFF VOICE\nIt's kind of scary here.\n\n> The End <");
  });

  //clear all text from fountain box
  $("#clear").click(function() {
    $("#fountain").val("");
  });

});
