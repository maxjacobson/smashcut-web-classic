$(document).ready(function(){
  var animateInit = $(window).width();
  animateInit -= 300;
  animateInit /= 2;
  var oldWidth = $(window).width(),
    newWidth, diff;
    $('#logo').animate({
      opacity: 1,
      left: '+=' + animateInit + 'px'
    }, 500, function() {});
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

// http://stackoverflow.com/questions/686995/jquery-catch-paste-input
// must they press the button or can they just paste it in and have it go?
// $('#smash').click(function() {
//     $('#logo').animate({
//         opacity: 0,
//         left: '+=50px'
//     }, 500, function() {});
//     $('#pastebox').animate({
//         opacity: 0
//     }, 500, function() {});
//     $('#previewbutton').animate({
//         opacity: 0
//     }, 500, function() {});
//     $('#footer').animate({
//         opacity: 0
//     }, 500, function() {});
// });