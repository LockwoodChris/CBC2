% Input vectors should be column vectors of dimension Nx1
% Both vectors should have the same dimension
function [confusionMatrix] = createConfusionMatrix(confusionMatrix, actual, predictions)
    for i = 1 : length(actual)
        currentValue = confusionMatrix(actual(i, :), predictions(i, :));
        confusionMatrix(actual(i, :), predictions(i, :)) = currentValue + 1;
    end
end