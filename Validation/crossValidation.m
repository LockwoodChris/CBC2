
% Performs k-fold cross validation on the given examples plus output label
function [confusionMatrix, avgRec, avgPrec, avgMeas, avgClassRate] = crossValidation(k, examples, outputLabels)
    numberOfExamples = length(examples);
    bucketSize       = floor(numberOfExamples / k);
    currentIndex     = 1;
    iterationNumber  = 1;
    
    confusionMatrix  = zeros(6, 6);
    recalls          = cell(k,6); 
    precisions       = cell(k,6);
    measures         = cell(k,6);
    sumClassError    = 0;
    
    while iterationNumber <= k
        testingSetSize  = currentIndex + bucketSize;
        
        % Divides example space into 3 parts :
        % 1) validation set on top of testing
        % 2) testing
        % 3) validation set below testing
        validationSet1    = examples(1 : (currentIndex - 1), :);
        validationLabels1 = outputLabels(1 : (currentIndex - 1), :);
        
        testSet          = examples(currentIndex : testingSetSize, :);
        testLabels       = outputLabels(currentIndex : testingSetSize, :);
           
        validationSet2    = examples((testingSetSize + 1) : numberOfExamples, :);
        validationLabels2 = outputLabels((testingSetSize + 1) : numberOfExamples , :);
        
        % Concatenates vertically both validation sets
        trueValidationSet    = vertcat(validationSet1, validationSet2);
        trueValidationLabels = vertcat(validationLabels1, validationLabels2);
        
        [T]      = createAllTrees(trueValidationSet, trueValidationLabels);
        
        predictions = testTrees(T, testSet); 
        
        sumClassError = sumClassError + classificationError(testLabels, predictions);
        
        % Updates confusion matrix with the newly introduced values
        confusionMatrix  = createConfusionMatrix(confusionMatrix, testLabels, predictions);
        % Loop to store recall, precision, f1measure per class
        for i = 1:6
            [recall, precision] = recallPrecisionRates(confusionMatrix, i);
            recalls{iterationNumber, i} = recall;
            precisions{iterationNumber, i} = precision;
            measures{iterationNumber, i} = f1measure(precision, recall);
        end
        
        currentIndex = currentIndex + bucketSize;
        iterationNumber = iterationNumber + 1;
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
    avgClassError = sumClassError / k;
    avgClassRate = 1 - avgClassError;
end

