% Function to calculate f1 measure
function [measure] = f1measure(precision, recall)
    
    measure = 2 * ((precision*recall)/(precision+recall));
end

