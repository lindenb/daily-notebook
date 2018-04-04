/**

auto-like pour instagram, à coller dans scratchpad.

faire apparaitre un tag eg. https://www.instagram.com/explore/tags/drawing/ avant de lancer



*/
function randomWait() {
   return (5 + Math.floor(Math.random() * 10)) * 1000;
}

function docHrefs(doc) {
  var array=[];
  var iter= doc.evaluate("//a[@href]",doc,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
  for(;;) {
    var a = iter.iterateNext();
    if(a==null) break;
    var att=a.getAttributeNode("href");

   if(att==null || 
     !att.value.startsWith("/p/") ||
     !att.value.includes("/?tagged=") ||
     array.includes(att.value)) continue;
    array.push(att.value);
    }
  return array;
  }

function fun1(scrolly) {
//
var posts_on_page= docHrefs(document);

function showig(array,idx) {
   if(idx>=array.length) {
   	window.scrollTo(0,scrolly);
   	fun1(scrolly + 10000 );
   	return;
   	}
   var s=array[idx];
   console.log(""+(idx+1)+"/"+array.length+" "+s+ " y="+scrolly);
   var win = window.open("https://www.instagram.com"+s,s);
   win.addEventListener('load', function() {
	  var iter2= win.document.evaluate(
		"//span[name(..) = 'A' and contains(@class,'coreSpriteHeartOpen')]",
		win.document
		,null,
		XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
		
	    var span =   iter2.iterateNext();
          
          if(span!=null)
            {
            setTimeout(function(){
              span.parentNode.click();
                setTimeout(function(){
                   win.close();
                   showig(array,idx+1);
                },randomWait());
               }, randomWait()); 
            }
          else
            {
            setTimeout(function(){
                win.close();
                showig(array,idx+1);
              }, randomWait());
            }
       });
   }
showig(posts_on_page,0);
}


fun1(0);


