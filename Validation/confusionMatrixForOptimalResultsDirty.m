% Takes dirty data set and calculates measures
function [confusionMatrix, avgRec, avgPrec, avgMeas, testError] = confusionMatrixForOptimalResultsDirty(x, y, results)
    k = 10;
    [ts1,te1, ts2, te2, vs, ve] = crossValidationIndexes(k, x, y);

    confusionMatrix  = zeros(6, 6);
    recalls          = cell(k,6); 
    precisions       = cell(k,6);
    measures         = cell(k,6);
    testError        = cell(k,1);

    for i = 1:k
        params = num2cell(results{3}{i});

        trainData = x([ts1{i}:te1{i} ts2{i}:te2{i}], :);
        trainLabels = y([ts1{i}:te1{i} ts2{i}:te2{i}], :);
        
        testData = x(vs{i}:ve{i}, :);
        testLabels = y(vs{i}:ve{i}, :);
        
        [testPredictions, ~] = singleRun(trainData, trainLabels, testData, testLabels, params);
        testError{i} = sum(testPredictions ~= testLabels)/size(testLabels, 1);
        
        % Updates confusion matrix with the newly introduced values
        confusionMatrix  = createConfusionMatrix(confusionMatrix, testLabels, testPredictions);
        % Loop to store recall, precision, f1measure per class
        for j = 1:6
           [recall, precision] = recallPrecisionRates(confusionMatrix, j);
           recalls{i, j} = recall;
           precisions{i, j} = precision;
           measures{i, j} = f1measure(precision, recall);
           if isnan(measures{i,j})
               fprintf('Precision: %d\n', precision);
               fprintf('Recall: %d\n', recall);
           end
        end
    end

     % Average the k recall, precision, f1measures for each class
     avgRec         = cell(6,1); 
     avgPrec        = cell(6,1);
     avgMeas        = cell(6,1);
     for i = 1:6
         avgRec{i}  = sum(cell2mat(cellfun(@double,recalls(:,i), 'un', 0)))/k;
         avgPrec{i} = sum(cell2mat(cellfun(@double,precisions(:,i), 'un', 0)))/k;
         avgMeas{i} = sum(cell2mat(cellfun(@double,measures(:,i), 'un', 0)))/k;
     end
     confusionMatrix = confusionMatrix / k;
end
