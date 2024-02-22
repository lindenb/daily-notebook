#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <Rinternals.h>
#include <Rembedded.h>
#include <R_ext/Parse.h>

#include <jni.h>
#include "RSession.h" // Incluez le fichier d'en-tête JNI généré

#define WHERE fprintf(stderr,"%s:%s:%d\n",__FILE__,__FUNCTION__,__LINE__)

int _argc=0;
char** _args = NULL;


JNIEXPORT jint JNICALL Java_RSession_initEmbeddedR(JNIEnv *env, jobject obj, jobjectArray argv) {
    int i;
    _argc = (*env)->GetArrayLength(env, argv);
    WHERE;
    _args = (char **)malloc((_argc+1) * sizeof(char *));
    _args[_argc]=NULL;
    for (i = 0; i < _argc; i++) {
        jstring string = (jstring)(*env)->GetObjectArrayElement(env, argv, i);
        const char *rawString = (*env)->GetStringUTFChars(env, string, 0);
        _args[i] = strdup(rawString);
         fprintf(stderr,"[%d] %s\n",i,_args[i]);
        (*env)->ReleaseStringUTFChars(env, string, rawString);
    }

    // Appelle la fonction C
        WHERE;

    int result = Rf_initEmbeddedR(_argc, _args);
    WHERE;

    WHERE;
    return result;
}

JNIEXPORT void JNICALL Java_RSession_endEmbeddedR(JNIEnv *env, jobject obj, jint fatal) {
    // Appelle la fonction C
    int i;
    Rf_endEmbeddedR(fatal);
    WHERE;
    // Libère la mémoire allouée pour les chaînes C
    for (i = 0; i < _argc; i++) {
        free(_args[i]);
    }
    free(_args);
}
