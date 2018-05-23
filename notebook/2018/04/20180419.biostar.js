function makeButton(root,textArea,title,content,author)
  {
  var but = document.createElement("button");
  root.insertBefore(but, root.firstChild);
  but.appendChild(document.createTextNode(title));
  but.addEventListener('click', function() {  
       textArea.value=content.replace("<uname>",author.name);
       }, false);
  }

var iter = document.evaluate(".//a[starts-with(@href,'/u/')][2]",document,null,XPathResult.ORDERED_NODE_ITERATOR_TYPE, null);
var aElement =  iter.iterateNext();
if( aElement !=null ) {
 var author={
   "id": aElement.getAttribute("href"),
   "name": aElement.textContent
 };

var E=document.getElementById("comment-row");
if(E!=null) {
  var iter2 = document.evaluate(".//textarea",E,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null);
  var textArea = iter2.iterateNext();
  if(textArea!=null) {
    makeButton(E,textArea,"Title","CONTENT <uname> hello",author);
    }
  }
}
