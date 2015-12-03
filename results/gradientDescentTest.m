%function [bestNet, bestParams] = gradientDescentTest()
load('./forstudents/cleandata_students.mat')
% params{1} = index for topology set (from 1 - 84)
% params{2} = 1, index for traingd
bestValidationError = Inf;
bestParams = [];
%results = i j 
testValErrorResults = cell(84, 3);
testNetResults = cell(84, 3);
for i =1:84
    % for each different learning rate
    for j = 1:3
        params = {i, 1, j};
        [avgTrainingError, avgValidationError, net] = crossValidation2(10, x, y, params);
        
        testValErrorResults{i, j} = avgValidationError;
        testNetResults{i, j} = net;
        
        if(bestValidationError > avgValidationError)
            bestValidationError = avgTrainingError;
            bestNet = net;
            bestParams = params;
        end
        
        s = sprintf('topology first %d, algorithm: %d', i, j);
        disp(s);
    end
end
disp(bestValidationError);
disp(bestParams);
results = {bestNet, bestParams, bestValidationError, testValErrorResults, testNetResults};
save('gdresults2.mat', 'results');
%end
