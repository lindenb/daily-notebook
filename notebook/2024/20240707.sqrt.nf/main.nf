List makeSQRT(def L1) {
	def key = L1.get(0);
	def L = L1.get(1).sort();
	int n = (int)Math.ceil(Math.sqrt(L.size()));
	def returnList = [];
	def currList = [];
	int i=0;
	for(;;) {
		if(i<L.size()) currList.add(L.get(i));
		if(i==L.size() || currList.size()==n) {
			if(!currList.isEmpty()) returnList.add([key,currList]);
			if(i==L.size()) break;
			currList=[];
			}
		i++;
		}
	return returnList;
	}

Channel.of(1..100).
	map{it->["X1",[""+it,""+it+".idx"]]}.
	groupTuple().
	flatMap{makeSQRT(it)}.
	map{[it[0],it[1].flatten()]}.
	view()
