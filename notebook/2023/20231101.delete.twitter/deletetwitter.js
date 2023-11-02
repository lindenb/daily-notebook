//<div aria-expanded="false" aria-haspopup="menu" aria-label="More" role="button"

state=0;
function confirmDelete() {
	var iter = document.evaluate("//span[text()='Delete' and  @style='text-overflow: unset;']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
	while(state==2) {
	    var a = iter.iterateNext();
	    if(a==null) break;
	    console.log("confirm");
	    setTimeout(function() {
			a.click();
			state=0;
		},2000);
	     break;
	    }
	}
function moreDelete() {
        console.log("moreDelete");
  	var iter = document.evaluate("//span[text()='Delete']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
	while(state==1) {
		var a = iter.iterateNext();
		if(a==null) break;
		console.log("moreDel");
	    	a.click();
		state=2;
		setTimeout(confirmDelete,2000);
		break;
		}
	}

function collect() {
  var iter = document.evaluate("//div[@aria-label='More' and @role='button']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
  while(state==0) {
    var a = iter.iterateNext();
    if(a==null) break;
    console.log("collect "+a);
    state=1;
    a.click();
    setTimeout(moreDelete,2000);
    break;
    }
} collect();



setInterval(collect, 2000);
