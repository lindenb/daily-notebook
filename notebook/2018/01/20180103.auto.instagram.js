/**

auto-like pour instagram, à coller dans scratchpad.

faire apparaitre un "liked-by" avant d'appeler 'run'



*/
function randomWait() {
   return (5 + Math.floor(Math.random() * 10)) * 1000;
}

function docHrefs(doc,filter) {
  var array=[];
  var iter= doc.evaluate("//a[@href]",doc,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
  for(;;) {
    var a = iter.iterateNext();
    if(a==null) break;
    var att=a.getAttributeNode("href");

    if(att==null || 
     att.value=="/explore/" ||
     att.value=="/yokofakun/" ||
      att.value=="/developer/" ||
     array.includes(att.value)) continue;
    
    if(filter!=null && !filter(att.value)) continue;
 
    array.push(att.value);
    }
  return array;
  }

function fun1() {
//
var users= docHrefs(document,function(v) {
  return v.match(/^\/[a-zA-Z0-9_]+\/$/); 
  });

function showig(array,idx) {
   if(idx>=array.length) return;
   var s=array[idx];
   var win = window.open("https://www.instagram.com"+s,s);
   win.addEventListener('load', function() {
    
     var images= docHrefs(win.document,function(s) {return s.match(/^\/p\//);});
     
     if(images.length>0)
       {
        setTimeout(function(){
       var image = images[Math.floor(Math.random() * images.length)];
       var win2= win.open("https://www.instagram.com"+image,image);
       setTimeout(function(){
              win.close();
          }, randomWait());
        win2.addEventListener('load', function() {
          
          var iter2= win2.document.evaluate(
            "//span[name(..) = 'A' and contains(@class,'coreSpriteHeartOpen')]",
            win2.document
            ,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
          var span =   iter2.iterateNext();
          
          if(span!=null)
            {
            setTimeout(function(){
              span.parentNode.click();
                setTimeout(function(){
                   win2.close();
                   showig(array,idx+1);
                },randomWait());
               }, randomWait()); 
            }
          else
            {
            setTimeout(function(){
                win2.close();
                showig(array,idx+1);
              }, randomWait());
            }
        });
        },randomWait());
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

showig(users,0);
}


fun1();


