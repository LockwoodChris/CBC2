function [] = ttest()
%Errors for 10 fold crossvalidation
cleanTrees = [0.237, 0.306, 0.227, 0.277, 0.217, 0.267, 0.267, 0.247, 0.227, 0.267];
cleanNets = [0.119, 0.109, 0.119, 0.148, 0.109, 0.149, 0.149, 0.01, 0.109, 0.089];

result = ttest2(cleanTrees, cleanNets);
disp(result);
end