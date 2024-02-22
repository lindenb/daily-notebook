public class RSession {
    // Déclaration des fonctions natives
    public static native int initEmbeddedR(String[] argv);
    public static native void endEmbeddedR(int fatal);

    // Charge la bibliothèque native lors du chargement de cette classe
    // Méthode main pour tester
    public static void main(String[] args) throws Throwable {

        final String R_HOME = System.getenv("R_HOME");
            if(R_HOME==null || R_HOME.isEmpty()) {
                System.err.println("undefined R_HOME");
                System.exit(-1);
                }

        final String libName= "RSession";
        System.err.println("##Trying load "+libName);
        try {
            System.loadLibrary(libName);
            }
        catch(Throwable err) {
            System.err.println("##Cannot load "+libName);
            err.printStackTrace();
            System.exit(-1);
            }
        System.err.println("##LOADED !! "+libName);

        // Exemple d'utilisation de la méthode initEmbeddedR
        String[] argv = {args[0],"--vanilla","--quiet","--encoding=UTF-8","--no-init-file","--no-readline"};
        //String[] argv = {"--vanilla","--verbose","--encoding=UTF-8","--no-init-file","--no-readline"};
        int result = RSession.initEmbeddedR(argv);
        System.out.println("initEmbeddedR returned result: " + result);

        // Exemple d'utilisation de la méthode endEmbeddedR
        RSession.endEmbeddedR(0);
        System.out.println("endEmbeddedR called successfully");
    }
}
