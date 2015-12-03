function [] = t_test()
cleanTrees = [0.237, 0.306, 0.227, 0.277, 0.217, 0.267, 0.267, 0.247, 0.227, 0.267];
cleanNets  = [0.119, 0.109, 0.119, 0.148, 0.109, 0.149, 0.149, 0.01, 0.109, 0.089];
A = cleanTrees-cleanNets;
[h, p] = ttest(A);
disp(h);
disp(p);


noisyTrees = [0.307, 0.326, 0.406, 0.396, 0.356, 0.366, 0.376, 0.425, 0.326, 0.287];
noisyNets  = [0.416, 0.554, 0.396, 0.327, 0.287, 0.416, 0.396, 0.366, 0.366, 0.426];
B = noisyTrees-noisyNets;
[h1,p1]= ttest(B);
disp(h1);
disp(p1);

end