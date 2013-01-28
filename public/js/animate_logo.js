$(document).ready(function(){
  $(window).ready(function() {
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
  });
});