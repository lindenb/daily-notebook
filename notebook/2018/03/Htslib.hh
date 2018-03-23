#ifndef HTSLIB_HH
#define HTSLIB_HH
#include <htslib/sam.h>
typedef int32_t genomic_position;


class Locatable
	{
	public:
		virtual char* contig() = 0;
		virtual genomic_position start() = 0;
		virtual genomic_position end() = 0;
	};
	
	

class Cigar
	{
	public:
		virtual int size();
		virtual char op(int i);
		virtual int length(int i);
			
	};


class SAMRecord : public Locatable
	{
	public:
		virtual char* read_name() = 0;
		virtual uint16_t flags() = 0;
		virtual bool has_flag(int flg) {
			return (flags() & flg)!=0;
			}
		virtual bool is_reverse_strand() {
			return has_flag(BAM_FREVERSE);
			}
		virtual bool is_mate_reverse_strand() {
			return has_flag(BAM_FMREVERSE);
			}
	};



class Bam1tWrapper : public SAMRecord
	{
	protected:
		bam1_t* rec;
		bam_hdr_t* header;
		bam1_core_t* core() {return &(rec->core);}
	public:
		Bam1tWrapper(bam1_t* rec,bam_hdr_t * h):rec(rec),header(h) {
		}
		virtual int32_t reference_index() { return core()->tid;}
		virtual int32_t reference_mate_index() { return core()->mtid;}
		virtual int32_t mapq() { return (int32_t)core()->qual;}
		virtual char* read_name() {return (char*)(rec->data)};
		virtual char* contig() {return this->name;}
		virtual genomic_position start() {return core()->pos;}
		virtual uint16_t flags() { return core()->flag;}
		virtual int32_t inferred_size() { return core()->isize;}
		 
		
	};


template<T>
class Iterator<T*>
	{
	public:
		bool hasNext();
		T* next();
		void close();
	};

class SamRecordIterator: public  Iterator<T>
	{
	private:
		bam1_t* b;
		Bam1tWrapper* read;
	public:
		SamRecordIterator() {
		  b = bam_init1();
		 
		  }
		
		next()  
		  
		void close() {
			::bam_destroy1(b);
			b = null;
		}
		~SamRecordIterator() {
			close();
		}
	};

class SamReader;

class SamReaderFactory {
public:
	SamReader* open(const char* fname) {
		samFile* fp = sam_open(fname, "r");
		bam_hdr_t* h = sam_hdr_read(fp);
		if (h == NULL) {
			
		    }
		return new SamReader(fp,h);
		}

};

class SamReader {
private:
	samFile* fp;
	
	
	class SamRecordIterator: public  Iterator<T> {
		private:
			samFile* fp;
			bam1_t* b;
			Bam1tWrapper* read;
		public:
			SamRecordIterator(samFile* fp) {
			  b = bam_init1();
			  read = new Bam1tWrapper(b);
			}
			
			
			Bam1tWrapper* read() {
			  if(b==NULL) return NULL;
			  int n = ::bam_read1(fp,b);
			  if(n<0) {
			  	
			  	}
			  }
			
			void close() {
				::bam_destroy1(b);
				b = NULL;
				read = NULL;
			}
			
			~SamRecordIterator() {
				close();
			}
		};

	
public:
	SamReader(samFile* fp):fp(fp) {
		
		}
        Iterator<SAMRecord*>* iterator() {
        	return new SamRecordIterator(fp);
        	}
	void close() 
		{
		sam_close(fp);
		}
};

#endif

