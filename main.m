% Load x and y from dataset
addpath(genpath('./'));
load('./forstudents/cleandata_students.mat');
[bestNets, bestErrors, bestConfig] = crossValidationEvaluation(10, x, y);
results = {bestNets, bestErrors, bestConfig};

save('crossValEval.mat', 'results');
