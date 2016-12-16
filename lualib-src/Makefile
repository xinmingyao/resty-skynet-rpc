all : cluster.so
cluster.so : lua-cluster.c lua-seri.c
	gcc -Wall -g -o $@ -fPIC --shared $^ -I ../lua/src -I./
