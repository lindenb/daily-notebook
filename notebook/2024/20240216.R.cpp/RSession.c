#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <Rinternals.h>
#include <Rembedded.h>
#include <R_ext/Parse.h>

#include <jni.h>
#include "RSession.h" // Incluez le fichier d'en-tête JNI généré

#define WHERE fprintf(stderr,"%s:%s:%d\n",__FILE__,__FUNCTION__,__LINE__)

JNIEXPORT void JNICALL Java_RSession_test
  (JNIEnv * env, jclass clazz) {
    WHERE;
   }



JNIEXPORT jint JNICALL Java_RSession_initEmbeddedR(JNIEnv *env, jobject obj, jint argc, jobjectArray argv) {
    WHERE;
    // Convertit les arguments de chaîne Java en tableau de chaînes C
    int i;
    int len = (*env)->GetArrayLength(env, argv);
    char **args = (char **)malloc(len * sizeof(char *));
    for (i = 0; i < len; i++) {
        jstring string = (jstring)(*env)->GetObjectArrayElement(env, argv, i);
        const char *rawString = (*env)->GetStringUTFChars(env, string, 0);
        args[i] = strdup(rawString);
         fprintf(stderr,"[%d] %s\n",i,args[i]);
        (*env)->ReleaseStringUTFChars(env, string, rawString);
    }

    // Appelle la fonction C
        WHERE;

    int result = Rf_initEmbeddedR(argc, args);
    WHERE;

    // Libère la mémoire allouée pour les chaînes C
    for (i = 0; i < len; i++) {
        free(args[i]);
    }
    free(args);
    WHERE;
    return result;
}

JNIEXPORT void JNICALL Java_RSession_endEmbeddedR(JNIEnv *env, jobject obj, jint fatal) {
    // Appelle la fonction C
    WHERE;
    Rf_endEmbeddedR(fatal);
    WHERE;
}
