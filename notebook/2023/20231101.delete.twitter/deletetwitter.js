
function confirmDelete() {
	var iter = document.evaluate("//span[text()='Delete' and  @style='text-overflow: unset;']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
	for(;;) {
	    var a = iter.iterateNext();
	    if(a==null) break;
	    console.log("confirm "+a);
	    setTimeout(function() {
			a.click();
		},2000);
	     break;
	    }
	}
function moreDelete() {
    console.log("moreDelete");
  	var iter = document.evaluate("//span[text()='Delete']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
	for(;;) {
		var a = iter.iterateNext();
		if(a==null) break;
		console.log("moreDel "+a);
	    a.click();
		setTimeout(confirmDelete,1000);
		break;
		}
	}

function undoRepost() {
	console.log("unretweet");
  	var iter = document.evaluate("//span[text()='Undo repost']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
	for(;;) {
		var a = iter.iterateNext();
		if(a==null) break;
		console.log("undo report "+a);
		setTimeout(function() {
			a.click();
			},2000);
		break;
		}
	}

function removeArticles() {
	var L=[];
	var iter = document.evaluate("//article[not(.//span/text()='yokofakun@genomic.social')]",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
	for(;;) {
		var a = iter.iterateNext();
    	if(a==null) break;
    	L.push(a);
		}
	for(i in L) {
		var a=L[i];
		if(a!=null && a.parentNode!=null) a.parentNode.removeChild(a);
		}
	}

function collect() {
  var has_repost = document.evaluate("//article[not(.//span/text()='You reposted')]",document,null,XPathResult.booleanValue, null);
  console.log("colllect");
  if(!has_repost) {
  	 console.log("no respot found");
  	  removeArticles();
	  var iter = document.evaluate("//div[@aria-label='More' and @role='button']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
	  for(;;) {
		var a = iter.iterateNext();
		if(a==null) break;
		console.log("post "+a);
		a.click();
		setTimeout(moreDelete,2000);
		break;
		}
	  }
  else {
  	console.log("got respot");
	  var iter = document.evaluate("//div[contains(@aria-label,'Reposted') and @role='button' and @data-testid='unretweet']",document,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
	 for(;;) {
		var a = iter.iterateNext();
		if(a==null) break;
		console.log("undoRepost "+a);
		a.click();
		setTimeout(undoRepost,2000);
		break;
		}
    }
} 

setInterval(collect, 10000);
