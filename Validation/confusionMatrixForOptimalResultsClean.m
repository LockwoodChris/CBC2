function [confusionMatrix, avgRec, avgPrec, avgMeas] = confusionMatrixForOptimalResultsClean(x, y, results)
    k = 10;
    [~,~, ~, ~, vs, ve] = crossValidationIndexes(k, x, y);


    confusionMatrix  = zeros(6, 6);
    recalls          = cell(k,6); 
    precisions       = cell(k,6);
    measures         = cell(k,6);

    for i = 1:k
        net = results{1}{i};

        testData = x(vs{i}:ve{i}, :);
        testLabels = y(vs{i}:ve{i}, :);

        testPredictions = testANN(net, testData);

        % Updates confusion matrix with the newly introduced values
        confusionMatrix  = createConfusionMatrix(confusionMatrix, testLabels, testPredictions);
        % Loop to store recall, precision, f1measure per class
        for j = 1:6
           [recall, precision] = recallPrecisionRates(confusionMatrix, j);
           recalls{i, j} = recall;
           precisions{i, j} = precision;
           measures{i, j} = f1measure(precision, recall);
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
     
     confusionMatrix
end
