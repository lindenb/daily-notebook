#include "htsfuse.hpp"

// http://www.maastaar.net/fuse/linux/filesystem/c/2016/05/21/writing-a-simple-filesystem-using-fuse/
//https://github.com/Labs22/BlackServerOS/blob/8a6191f732d97e34adba5f2da343fed6f02a56a3/cryptography/android-fde-master/android-fde-master/read_emmc/usb.cpp
//https://github.com/cordalace/ffmc/blob/077af9bc9c43443e82255194b634ea2bcb0d9a75/main.c
using namespace std;


FSNode::FSNode(xmlDocPtr dom,xmlNodePtr root,FSNode* parent):parent(parent),user(0),password(0) {
    if(parent==0)
    	{
    	if(::xmlHasProp(root, BAD_CAST "name")!=NULL)
    		{
    		fprintf(stderr,"[WARN]@name ignored in root node.\n");
    		}
    	this->path.assign("/");
    	}
    else
    	{
    	this->path.assign(parent->path);
    	
	 xmlChar *s = ::xmlGetProp(root, BAD_CAST "name");
	 if(s==NULL) {
		fprintf(stderr,"[FATAL]@name is missing in <%s>.\n", (const char*)root->name);
		abort();
	    	}
	    this->token.assign((char*)s);
	    ::xmlFree(s);
	    this->path.append("/");
	    this->path.append(token);
    	}
    this->user =  ::xmlGetProp(root, BAD_CAST "user");
    this->password =  ::xmlGetProp(root, BAD_CAST "password");
    }
		    
FSNode::~FSNode() {
    ::xmlFree(this->user);
    ::xmlFree(this->password);
    }

bool FSNode::is_directory() { return !is_file();}
bool FSNode::is_root() { return parent==0;}

		

FSDirectory::FSDirectory(xmlDocPtr dom,xmlNodePtr root,FSNode* parent):FSNode(dom,root,parent) {
	if(::strcmp((const char*)root->name,"directory")!=0) {
		fprintf(stderr,"[FATAL] Not directory <%s>.\n",(const char*)root->name);
		abort();
		}
	xmlNodePtr cur_node;
	for (cur_node = xmlFirstElementChild(root); cur_node!=NULL; cur_node = xmlNextElementSibling(cur_node)) {
		if(strcmp((const char*)cur_node->name,"directory")==0) {
			FSDirectory* c = new FSDirectory(dom,cur_node,this);
			children.push_back(c);
			}
		else if(strcmp((const char*)cur_node->name,"file")==0) {
			FSFile* c = new FSFile(dom,cur_node,this);
			children.push_back(c);
			}
		else 
			{
			fprintf(stderr,"[WARN] ignoring <%s>.\n", (const char*)cur_node->name);
			}
		}
	}

bool FSDirectory::is_file() { return false;}
		
FSDirectory::~FSDirectory() {
	for(size_t i=0;i< children.size();++i) {
		delete children[i];
		}
	children.clear();
	}

FSNode* FSDirectory::find(const char* pathstr) {
	if(this->path.compare(pathstr)==0) return this;
	for(size_t i=0;i< children.size();++i) {
		FSNode* n = children[i]->find(pathstr);
		if(n!=0) return n;
		}
	return 0;
	}
	
int FSDirectory::readdir(void *buffer, fuse_fill_dir_t filler) {
	filler(buffer, ".", NULL, 0);
	filler(buffer, "..", NULL, 0);
	for(size_t i=0;i< children.size();++i) {
		FSNode* n = children[i];
		filler(buffer,n->token.c_str(), NULL, 0);
		}
	return 0;
	}
int FSDirectory::getattr(struct stat *stbuf) {
	std::memset(stbuf, 0, sizeof(struct stat));
	stbuf->st_mode = S_IFDIR | 0755;
	stbuf->st_nlink = 2;
	return 0;
	}

	
FSFile::FSFile(xmlDocPtr dom,xmlNodePtr root,FSNode* parent):FSNode(dom,root,parent),content_length_ptr(0) {
	if(strcmp((char*)root->name,"file")!=0) {
		fprintf(stderr,"[FATAL] Not file <%s>.\n",(const char*)root->name);
		abort();
		}
	 xmlChar *s = ::xmlGetProp(root, BAD_CAST "url");
	 if(s==NULL) s= ::xmlGetProp(root, BAD_CAST "href");
	 if(s==NULL) s= ::xmlGetProp(root, BAD_CAST "src");
	 if(s==NULL) {
		fprintf(stderr,"[FATAL]@url is missing in <%s>.\n", (const char*)root->name);
		abort();
	    	}
	 this->url.assign((char*)s);
	 ::xmlFree(s);
	}
		
bool FSFile::is_file() { return true;}

FSFile::~FSFile() {
if(content_length_ptr!=NULL) delete content_length_ptr;
}


size_t read_content_callback(char *buffer,   size_t size,   size_t nitems,   void *userdata) {
	std::string* content=(string*)userdata;
	content->append(buffer,size*nitems * size);
	return nitems * size;
	}


size_t FSFile::length() {
	if(content_length_ptr==NULL) {
		 string header;
		 CURL* curl = this->create_curl();
		 curl_easy_setopt(curl, CURLOPT_NOBODY, 1L);
		 curl_easy_setopt(curl, CURLOPT_HEADER, 0L);
		 
		 curl_easy_setopt(curl, CURLOPT_HEADERDATA, &header);
		 curl_easy_setopt(curl, CURLOPT_HEADERFUNCTION, read_content_callback);
		
		  CURLcode res = curl_easy_perform(curl);
		 /* Check for errors */
		 if(res != CURLE_OK) {
		  	fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
		 	}
		 else
		 	{
		 	std::istringstream iss(header);
		 	std::string line;
		 	std::string content_length_token("Content-Length:");
			while (std::getline(iss, line))
				{
				if(line.find(content_length_token)==0)
					{
					line.erase(0,content_length_token.size());
					long content_length= strtoul(line.c_str(),NULL,10);
					content_length_ptr = new  size_t;
					*content_length_ptr = content_length;
					break;
					}
				}
		 	}
		curl_easy_cleanup(curl);
		
		if(content_length_ptr==NULL) {
			fprintf(stderr, "Cannot get length %s\n", url.c_str());
			content_length_ptr = new  size_t;
			*content_length_ptr = 0UL;
			}
		}
	return *content_length_ptr;
	}

FSNode* FSFile::find(const char* pathstr) {
	if(this->path.compare(pathstr)==0) return this;
	return 0;
	}

int FSFile::readdir(void *buffer, fuse_fill_dir_t filler) {
	fprintf(stderr,"[LOG]readdir asked for file.\n");
	return 0;
	}

int FSFile::getattr(struct stat *stbuf) {
	stbuf->st_mode = S_IFREG | 0444;
	stbuf->st_nlink = 1;
	stbuf->st_size = this->length();
	return 0;
	}


FSFileReader::FSFileReader(FSFile* f):fsFile(f),pos(0UL) {
}

FSFileReader::~FSFileReader() {
}




CURL* FSFile::create_curl() {
	 CURL *curl = ::curl_easy_init();
	 if(curl==NULL) {
		fprintf(stderr,"[ERROR]::curl_easy_init failed\n");
		abort();
		}
	 
	 curl_easy_setopt(curl, CURLOPT_URL, this->url.c_str());
	 
	 FSNode* curr=this;
	 while(curr!=NULL)
	 	{
	 	if(curr->user!=NULL)
	 		{
			curl_easy_setopt(curl, CURLOPT_USERNAME,(const char*)curr->user);
			break;
			}
		curr = curr->parent;
		}
	curr=this;
	 while(curr!=NULL)
	 	{
	 	if(curr->password!=NULL)
	 		{
			curl_easy_setopt(curl, CURLOPT_PASSWORD,(const char*)curr->password);
			break;
			}
		curr = curr->parent;
		}
	 curl_easy_setopt(curl, CURLOPT_USERAGENT, "Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:62.0) Gecko/20100101 Firefox/62.0");
	 curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 1L);
	 

	return curl;
	}

int FSFile::read(char *buffer, size_t size, off_t offset) {
	 
	 if(offset+size> this->length())
	 	{
	 	size = this->length()-offset;
	 	}
	 if(size==0UL) return 0;
	 
	 CURL* curl = this->create_curl();
	 curl_easy_setopt(curl, CURLOPT_NOBODY, 0L);
	 curl_easy_setopt(curl, CURLOPT_HEADER, 0L);
	 string content;
	 curl_easy_setopt(curl, CURLOPT_HEADERDATA, &content);
	 curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, read_content_callback);
	 //curl_easy_setopt(curl, CURLOPT_BUFFERSIZE, CURL_MAX_READ_SIZE );

	 char tmp_range[1000];
	 sprintf(tmp_range,"%lld-%lld",offset,offset+size);
	 
	 curl_easy_setopt(curl, CURLOPT_RANGE, tmp_range);
	 
	  CURLcode res = curl_easy_perform(curl);
	 /* Check for errors */
	 if(res != CURLE_OK) {
	  	fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
	 	}
	 curl_easy_cleanup(curl);
	 memcpy(buffer,content.data(),size);
	return 0;
	}

static FSDirectory* fs_root = NULL;

static int htsfuse_getattr(const char *path, struct stat *stbuf) {
fprintf(stderr,"call htsfuse_getattr\n");
FSNode* node = fs_root->find(path);
  if(node==NULL) {
  	fprintf(stderr,"File not found %s\n",path);
  	return -ENOENT;
	}
  node->getattr(stbuf);
  return 0;
}

static int htsfuse_readdir(const char *path, void *buffer, fuse_fill_dir_t filler, off_t offset, fuse_file_info *fi) {
   fprintf(stderr,"call htsfuse_readdir\n");
  FSNode* node = fs_root->find(path);
  if(node==NULL) {
  	fprintf(stderr,"File not found %s\n",path);
  	return -ENOENT;
	}
  node->readdir(buffer,filler);
  return 0;
}



static int htsfuse_open(const char *path,struct fuse_file_info *fi) {
   fprintf(stderr,"call htsfuse_open\n");
  FSNode* node = fs_root->find(path);
  if(node==NULL || !node->is_file()) return -ENOENT;

  fi->fh = (uint64_t) new FSFileReader((FSFile*)node);

  return 0;
}

static int htsfuse_release(const char *path,struct fuse_file_info *fi) {
  fprintf(stderr,"call htsfuse_release\n");
  FSFileReader* r = (FSFileReader*)fi->fh;
  delete r;
  return 0;
}

static int htsfuse_read(const char *path, char *buffer, size_t size, off_t offset,struct fuse_file_info *fi) {
  FSFileReader* r = (FSFileReader*)fi->fh;
  fprintf(stderr,"call htsfuse_read\n");
  return r->fsFile->read(buffer,size,offset);
}


void _onexit(void) {
	fprintf(stderr,"AT EXIT CALLED########################\n");
	
	}

int main(int argc,char** argv)
	{
	LIBXML_TEST_VERSION
	 curl_global_init(CURL_GLOBAL_ALL);
	if(argc<3) {
       		fprintf(stderr,"XML file / MOUNT_DIR .\n");
       		return EXIT_FAILURE;
    		}
	 xmlDoc *doc = ::xmlReadFile(argv[1], NULL, 0);

	if (doc == NULL) {
       		fprintf(stderr,"error: could not parse XML file %s\n", argv[1]);
       		return EXIT_FAILURE;
    		}
    	fs_root = new FSDirectory(doc,xmlDocGetRootElement(doc),0);
    	
	::xmlFreeDoc(doc);
	::xmlCleanupParser();
	
	struct fuse_operations operations;
	operations.open = htsfuse_open;
	operations.read = htsfuse_read;
	operations.release = htsfuse_release;
	operations.readdir = htsfuse_readdir;
	operations.getattr = htsfuse_getattr;
	atexit(_onexit);
	fprintf(stderr, "######################fuse_main start\n");
	int ret= fuse_main( argc-1, &argv[1], &operations,NULL );
	fprintf(stderr, "######################fuse_main returned %d\n", ret);
	//delete fs_root;
	
	return ret;
	}
