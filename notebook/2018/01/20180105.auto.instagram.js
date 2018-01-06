/*
 * This is a JavaScript Scratchpad.
 *
 * Enter some JavaScript, then Right Click or choose from the Execute Menu:
 * 1. Run to evaluate the selected text (Ctrl+R),
 * 2. Inspect to bring up an Object Inspector on the result (Ctrl+I), or,
 * 3. Display to insert the result in a comment after the selection. (Ctrl+L)
 */

function randomWait() {
  return (5 + Math.floor(Math.random() * 10)) * 1000;
}

function randomComment() {
   var comments=["Wow","I like it","Excellent","Cool"];
   return comments[Math.floor(Math.random() * comments.length)];
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
            
             var iter3= win2.document.evaluate(
                "//textarea[starts-with(@placeholder,'Add a comment')]",
                win2.document
                ,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
            var textarea =   iter3.iterateNext();
                           
            
              
              
            var iter4  = win2.document.evaluate(
                "//meta[contains(@content,' Likes') and @name='description']/@content",
                win2.document
                ,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
           
                       
            var numlikes =   iter4.iterateNext(); 
            
            var has_tag = false;
            var tags=["drawing","draw","comicart","drawingoftheday","sketching","sketch"];
            for(t in tags)
              {
              if(has_tag) break;
              var iter5  = win2.document.evaluate(
                "//a[@href='/explore/tags/"+ tags[t]+ "/']",
                win2.document
                ,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
              if( iter5.iterateNext()!=null) {has_tag=true;break;}
              }
            
              
            var fun1 = function(){
                span.parentNode.click();
                  setTimeout(function(){
                     win2.close();
                     showig(array,idx+1);
                  },randomWait());
                 };  
              
              
            if(has_tag && textarea!=null && numlikes!=null && 
               parseInt(numlikes.nodeValue.replace(/ Likes.*$/,'').replace(/[,]/g,''))>100 &&
               textarea.parentNode.nodeName.toLowerCase()=="form")
                {
                setTimeout(function(){
                  textarea.value = randomComment();
                  textarea.parentNode.submit();
                  setTimeout(fun1, randomWait()); 
                  }, randomWait()); 
                } 
            else
              {
              setTimeout(fun1, randomWait()); 
              }/* text area */
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



