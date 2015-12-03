load('./forstudents/cleandata_students.mat')
% params{1} = index for topology set (from 1 - 84)
% params{2} = 1, index for traingd

bestValidationError = Inf;
bestParams = [];
%results = i j 
testValErrorResults = cell(84, 3, 3);
testNetResults = cell(84, 3, 3);
for i =1:84
    % for each different learning rate
    for j = 1:3 % learning rate
        for k = 1:3 % adaptive increase rate
            params = {i, 3, j, k};
            [avgTrainingError, avgValidationError, net] = crossValidation2(10, x, y, params);
        
            testValErrorResults{i, j, k} = avgValidationError;
            testNetResults{i, j, k} = net;
        
            if(bestValidationError > avgValidationError)
                bestValidationError = avgTrainingError;
                bestNet = net;
                bestParams = params;
            end
            s = sprintf('topology first %d, algorithm: %d, %d', i, j, k);
            disp(s);
        end
    end
end
disp(bestValidationError);
disp(bestParams);
results = {bestNet, bestParams, bestValidationError, testValErrorResults, testNetResults};
save('gdmresults2.mat', 'results');