$(document).ready(function(){  
	
    $('.galleryitem img').animate({height: 100}, 0); //Set all menu items to smaller size  
    
    $('.galleryitem img').filter(":first").animate({height: 350}, 100); //Set first to larger size
  
    $('.galleryitem').click(function(){ 
	  
	    $('.galleryitem img').animate({height: 100}, 100);
        gridimage = $(this).find('img'); //Define target as a variable  
        gridimage.stop().animate({height: 350}, 300); //Animate image expanding to original size  
  
    });
}); 