import org.chocosolver.solver.*;
import org.chocosolver.solver.variables.*;

public class Choco01 {
	private void run(final String[] args) throws Exception {
		int n = 8;
	Model model = new Model(n + "-queens problem");
	/* A variable is an unknown which has to be assigned to value in a solution. */
	IntVar[] vars = new IntVar[n];
	for(int q = 0; q < n; q++){
	   /* Thus, there will be n queens (one per row), each of them to be assigned to one column, among [1,n]. */
		vars[q] = model.intVar("Q_"+q, 1, n);
	}
	for(int i  = 0; i < n-1; i++){
		for(int j = i + 1; j < n; j++){
			/** So, for each pair of queens, the two related variables cannot be assigned to the same value.  */
		    model.arithm(vars[i], "!=",vars[j]).post();
		    /* Second, the diagonals: we have to consider the two orthogonal diagonals. If the queen i is on column k, then, the queen i+1 cannot be assigned to k+1. More generally, the queen i+m cannot be assigned to k+m. The same goes with the other diagonal. */
		    model.arithm(vars[i], "!=", vars[j], "-", j - i).post();
		    model.arithm(vars[i], "!=", vars[j], "+", j - i).post();
		}
	}
	Solution solution = model.getSolver().findSolution();
	if(solution != null){
		System.out.println(solution.toString());
	}

	}
	
	
	public static void main(final String[] args) {
		try {
			new Choco01().run(args);
			System.err.println("done");
			}
		catch(Throwable err) {
			err.printStackTrace();
			}
		}
	
	}
