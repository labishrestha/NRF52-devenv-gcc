set history filename .gdb_history
set history save on
set history size unlimited
set history expansion on
set confirm off
target extended-remote:3333
monitor reset init
monitor reset init
load
b main
c
