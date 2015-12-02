% Load x and y from dataset
%addpath(genpath('.'));
[bestNets, bestErrors, bestConfig] = crossValidationEvaluation(10, x, y);
results = {bestNets, bestErrors, bestConfig};

save('crossValEval.mat', 'results');