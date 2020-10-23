var drag = false;
var win;
var aktivX, aktivY;

document.onmousemove = mmove;
document.onmouseup = mup;

function mmove(e)
{
	if( !e ) {
	    	 if( window.event ) {
	      		e = window.event;
	    	 } else {
	     	 	return;
	   	 }
   	}

	if (drag){
		if (e.pageX)
		{
			neuX = e.pageX;
			neuY = e.pageY;
		}else{
			neuX = e.clientX + document.body.scrollLeft;
			neuY = e.clientY + document.body.scrollTop;
		}
		
		
		
		var distX = (neuX-aktivX);
		var distY = (neuY-aktivY);
		
		aktivX = neuX;
		aktivY = neuY;
		
		win.style.left =  (parseInt(win.style.left) + distX) + 'px';
   		win.style.top  =  (parseInt(win.style.top) + distY) + 'px';
        }
}

function mdown(e, element)
{
	if( !e ) {
    	 if( window.event ) {
      		e = window.event;
    	 } else {
     	 	return;
   	 }
   	}

	win = element;
	drag = true;
	
	if (e.pageX)
	{
		aktivX = e.pageX;
		aktivY = e.pageY;
	}else{
		aktivX = e.clientX + document.body.scrollLeft;
		aktivY = e.clientY + document.body.scrollTop;
	}	
	return false;

}

function mup()
{
	drag = false;
	win = null;	
}