using Funs

c = rand(1000);
x=rand(10000);
f=Fun(c);

tic();y=f[x];toc()
#0.012482274


tic();y=f[.1];toc()
#0.000352981

