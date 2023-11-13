params.f1="NO_FILE"
params.f2="NO_FILE"

workflow {
	ch1 = Channel.fromPath(params.f1)
	ch2 = Channel.fromPath(params.f2)
	ch3 = Channel.of(["x1":"ABC",x2:1234])

	ch1.combine(ch2).combine(ch3).
		splitCsv(sep:'\t',header:true).
		splitCsv(sep:'\t',header:true).
		view{"${it}\n"}
	}
