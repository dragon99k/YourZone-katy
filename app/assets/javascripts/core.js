$(document).ready(function(){  
	"use strict";
	
	//smooth anchor
		$('a[href*="#"]:not(a[href="#"])').click(function() {
    	if(location.pathname.replace(/^\//,'') === this.pathname.replace(/^\//,'') && location.hostname === this.hostname) {
      		var target = $(this.hash);
      		target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      		if (target.length) {
        		$('html,body').animate({
          			scrollTop: target.offset().top
        		}, 500);
        		return false;
      		}
    	}
  	});
	
	//hamburger menu
	$('#menu').click(function(){
		if($('body').hasClass('menu-visible')){
			$(this).removeClass('active');
			$('body').removeClass('menu-visible');
		}else{
			$(this).addClass('active');
			$('body').addClass('menu-visible');
		}
	});
	$('#obfuscator').click(function(){
		$('#menu').removeClass('active');
		$('body').removeClass('menu-visible');
	});

  
	
/*########################################################################
##   Add-on  ################################################################
########################################################################*/
/*	

	//rellax (https://github.com/dixonandmoe/rellax)
	if ($(".rellax").length > 0) {
		var rellax = new Rellax('.rellax');
		rellax;
	}
	
	
	//nicescroll (https://github.com/inuyaksa/jquery.nicescroll/blob/master/README.md)
	$("html").niceScroll();
	
	
	//inview wow plugin combined with animate.css (https://wowjs.uk/docs)
	function offset(){
         $( ".inview" ).each(function() {
             var windowHeight = $(window).height();
             var offset;
            if ($(this).attr('data-wow-center-offset')) {
                offset = windowHeight / 100 * $(this).attr('data-wow-center-offset');
            }
            else {
                offset = windowHeight * 0.15;
            }
            offset = offset + $(this).height() / 2;
            $(this).attr( "data-wow-offset", parseInt(offset) );
        });
     }
    offset();
    $(window).resize(function(){
        offset();
    });
    
	if ($(".inview").length > 0) {
		new WOW({
            boxClass:     'inview'
        }).init();
	}
	
	
	// change <img> to background-image
	var imgToBackground = function () {
		$("img.bg").each(function () {
			$(this).parent().css({
				backgroundImage: "url(" + $(this).attr("src") + ")"
			});
		});
	};
	imgToBackground();
	
*/
//end of Document
});
