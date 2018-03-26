var URL = Java.type("java.net.URL");

function sql(s) {
	return (""+s).replace(/([^ a-zA-Z_0-9,;\.\-])+/g,' ');
	}
function quote(s) {
	return "'"+sql(s)+"'";
	}
	
function readURL(url) {
	java.lang.System.err.println(url);
        var is=null;
        try {
		is =new URL(url).openStream();
		var buf = '',c;
		while ((c = is.read()) != -1) {
			buf += String.fromCharCode(c);
			}
		is.close();is=null;
		return buf;
		}
	catch(e) {
		return null;
		}
        finally
        	{
        	if(is!=null) is.close();
        	}
	}
 
 function readPost(postID) {
  var url = "https://www.biostars.org/api/post/"+postID;
  
  var buf = readURL(url);
  if(buf==null) return null;
  return JSON.parse(buf);
  }
 
print("create table post(id id,creation_date text,comment_count int,answer_count int,author text,author_id int, has_accepted int,reply_count int,status text,view_count int,vote_count int,title int) ; begin transaction;" );

var postid = 305843;
while(postid>0)
	{
	var post = readPost(postid);
	if(post!=null && post.type=="Question") {
		print("insert into post(id,creation_date,comment_count,answer_count,author,author_id,has_accepted,reply_count,status,view_count,vote_count,title) values("
			+ sql(post.id) + ","
			+  "'"+ post.creation_date + "',"
			+ sql(post.comment_count) + ","
			+ sql(post.answer_count) + ","
			+ quote(post.author) + ","
			+ sql(post.author_id) + ","
			+ sql(post.has_accepted?"1":"0") + ","
			+ sql(post.reply_count) + ","
			+ quote(post.status) + ","
			+ sql(post.view_count) + ","
			+ sql(post.vote_count) + ","
			+ quote(post.title) 
			+ ");");
		}
	postid--;
	}
print("commit;");
