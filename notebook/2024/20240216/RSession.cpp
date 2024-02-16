 #include <Rinternals.h>
 #include <Rembedded.h>
 #include <R_ext/Parse.h>

using namespace std;

/** https://stackoverflow.com/questions/2463437 */
class RSession {
public:
	RSession()  {
		char *localArgs[] = {(char*)"R", (char*)"--no-save",(char*)"--silent"};
		::Rf_initEmbeddedR(3,localArgs);
		}
	~RSession() {
		::Rf_endEmbeddedR(0);
		}

};


int main(int argc,char** argv) {
	RSession session;
	return 0;
	}
