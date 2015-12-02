function [bestNet, bestParams] = gradientDescentTest(x, y)
    % params{1} = index for topology set (from 1 - 89)
    % params{2} = 1, index for traingd
    bestValidationError = Inf;
    bestParams = [];
    for i =1:84
        % for each different learning rate
        for j = 1:3
            params = {i, 1, j};
            [avgTrainingError, avgValidationError, net] = crossValidation(10, x, y, params);
            if(bestValidationError > avgValidationError)
                bestValidationError = avgTrainingError;
                bestNet = net;
                bestParams = params;
            end
        end
    end
    disp(bestValidationError);
    disp(bestParams);
end
