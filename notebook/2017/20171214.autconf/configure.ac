
AC_INIT(program, 1.0)


AC_PROG_CC
AC_CONFIG_HEADERS(config.h)


AC_ARG_WITH(guile, [AS_HELP_STRING([--with-guile], [use gnu guile])])


if test "$with_guile" != no
then
	AC_MSG_CHECKING(for Guile)
	guile-config link > /dev/null || {
	    echo "configure: cannot find guile-config; is Guile installed?" 1>&2
	    exit 1
	  }
	GUILE_CFLAGS="`guile-config compile`"
	GUILE_LDFLAGS="`guile-config link`"
	GUILE_DATADIR="`guile-config info pkgdatadir`"
	AC_SUBST(GUILE_CFLAGS)
	AC_SUBST(GUILE_LDFLAGS)
	AC_SUBST(GUILE_DATADIR) 
	  
 	PKG_CHECK_MODULES([GUILE],[guile-2.0])
 	AC_CHECK_HEADERS([libguile.h], [], [AC_MSG_ERROR([guile include files not found])])
 	AC_CHECK_LIB([guile], [scm_with_guile], [AC_MSG_ERROR([guile library files not found])])
fi




dnl Process Makefile.in to create Makefile

AC_OUTPUT(Makefile)



