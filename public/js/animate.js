$(document).ready(function(){
  
  var pagewidth = $('#html').width();
  pagewidth -= 300;
  pagewidth /= 2;
  
    $('#logo').animate({
      opacity: 1,
      left: '+=' + pagewidth + 'px'
    }, 500, function() {});
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
});

// http://stackoverflow.com/questions/686995/jquery-catch-paste-input
// must they press the button or can they just paste it in and have it go?