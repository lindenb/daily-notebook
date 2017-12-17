
AC_INIT(program, 1.0)


AC_PROG_CC
AC_CONFIG_HEADERS([config.h])

dnl https://stackoverflow.com/questions/47819563

AC_ARG_WITH(guile, [AS_HELP_STRING([--with-guile], [use gnu guile])],
           [with_guile=yes],[with_guile=no])

AS_IF([test "x$with_guile" = xyes],
   [AC_CHECK_PROG([GUILE_CONFIG],[guile-config],[guile-config])
    AS_IF([test -z "$GUILE_CONFIG"],[AC_MSG_FAILURE([cannot find guile-config])])
    CFLAGS="$CFLAGS `$GUILE_CONFIG compile`"
    LDFLAGS="$LDFLAGS `$GUILE_CONFIG link`"
    AC_DEFINE([HAVE_GUILE],[1],[Guile supported])])
 AC_CONFIG_FILES([Makefile])
 AC_OUTPUT

