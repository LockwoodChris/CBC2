load('./forstudents/noisydata_students.mat');
load('./crossValEval.mat');
[confusionMatrix, avgRec, avgPrec, avgMeas, testError] = confusionMatrixForOptimalResultsDirty(x, y, results);
noisy_results = struct;
noisy_results.confusionMatrix = confusionMatrix;
noisy_results.avgRc = avgRec;
noisy_results.avgPrec = avgPrec;
noisy_results.avgMeas = avgMeas;
noisy_results.testError = testError;

save('noisy_results.mat', 'noisy_results');