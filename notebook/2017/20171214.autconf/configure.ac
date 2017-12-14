
AC_INIT(program, 1.0)


AC_PROG_CC
AC_CONFIG_HEADERS(config.h)

with_guile=no

AC_ARG_WITH(guile, [AS_HELP_STRING([--with-guile], [use gnu guile])],[],[with_guile=yes])


if test "x$with_guile" != no
then
	AC_MSG_CHECKING(for Guile)
	guile-config link > /dev/null || {
	    echo "configure: cannot find guile-config; is Guile installed?" 1>&2
	    exit 1
	  }
	CFLAGS="$CFLAGS `guile-config compile`"
	LDFLAGS="$LDFLAGS `guile-config link`"
	AC_DEFINE([HAVE_GUILE],[1],[Guile supported])
 
 	#PKG_CHECK_MODULES([GUILE],[guile-2.0])
 	#AC_CHECK_HEADERS([libguile.h], [], [AC_MSG_ERROR([guile include files not found])])
 	#AC_CHECK_LIB([guile], [scm_with_guile], [AC_MSG_ERROR([guile library files not found])])
fi


dnl Process Makefile.in to create Makefile

AC_OUTPUT(Makefile)



