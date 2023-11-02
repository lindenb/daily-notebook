state=0;
function confirmDelete() {
	var iter = document.evaluate("//span[text()='Delete' and  @style='text-overflow: unset;']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
	while(state==2) {
	    var a = iter.iterateNext();
	    if(a==null) break;
	    console.log("confirm "+a);
	    setTimeout(function() {
			a.click();
			a.parentNode.removeChild(a);
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
		console.log("moreDel "+a);
	    a.click();
		state=2;
		setTimeout(confirmDelete,2000);
		break;
		}
	}

function undoRepost() {
	console.log("unretweet");
  	var iter = document.evaluate("//span[text()='Undo repost']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
	while(state==1) {
		var a = iter.iterateNext();
		if(a==null) break;
		console.log("undo report "+a);
		    setTimeout(function() {
			a.click();
			a.parentNode.removeChild(a);
			state=0;
			},2000);
		break;
		}
	}

function collect() {
  console.log("colllect");
  state=0;
  var iter = document.evaluate("//div[@aria-label='More' and @role='button']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
  while(state==0) {
    var a = iter.iterateNext();
    if(a==null) break;
    console.log("post "+a);
    state=1;
    a.click();
    setTimeout(moreDelete,2000);
    break;
    }
  state=0;
  iter = document.evaluate("//div[contains(@aria-label,'Reposted') and @role='button' and @data-testid='unretweet']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
  while(state==0) {
    var a = iter.iterateNext();
    if(a==null) break;
    console.log("undoRepost "+a);
    state=1;
    a.click();
    setTimeout(undoRepost,2000);
    break;
    }


} 

setInterval(collect, 10000);
