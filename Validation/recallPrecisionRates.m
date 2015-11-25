% Function to calculate recall and precision given a confusion matrix and
% the class in the matrix 
function [recall, precision] = recallPrecisionRates(confusionMatrix, class)
    classes = size(confusionMatrix,1);
    truePositives = confusionMatrix(class,class);
    
    falsePositives = 0;
    for i = 1:classes
        falsePositives = falsePositives + confusionMatrix(class,i);
    end
    
    precision = truePositives/(truePositives + falsePositives);
    
    falseNegatives = 0;
    for i =1:classes
        falseNegatives = falseNegatives + confusionMatrix(i,class);
    end
    
    recall = truePositives/(truePositives + falseNegatives);
end