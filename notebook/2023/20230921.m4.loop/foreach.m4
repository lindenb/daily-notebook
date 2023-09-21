define(`foreach', `pushdef(`$1', `')_foreach(`$1', `$2', `$3')popdef(`$1')')dnl
define(`_arg1', `$1')dnl
define(`_foreach',`ifelse(`$2', `()', ,`define(`$1', _arg1$2)$3`'_foreach(`$1', (shift$2), `$3')')')dnl
