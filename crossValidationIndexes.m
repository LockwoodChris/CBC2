
% Performs k-fold cross validation on the given examples plus output label
function [valIndexSetStart1, valIndexSetEnd1, valIndexSetStart2, valIndexSetEnd2, testIndexSetStart,testIndexSetEnd] = crossValidationIndexes(k, examples, outputLabels)
    numberOfExamples = length(examples);
    bucketSize       = floor(numberOfExamples / k);
    currentIndex     = 1;
    iterationNumber  = 1;
    
    valIndexSetStart1= cell(k,1); 
    valIndexSetEnd1  = cell(k,1);
    valIndexSetStart2= cell(k,1);
    valIndexSetEnd2  = cell(k,1);
    
    testIndexSetStart= cell(k,1);
    testIndexSetEnd  = cell(k,1);
    
    while iterationNumber <= k
        testingSetSize  = currentIndex + bucketSize;
        
        % Divides example space into 3 parts :
        % 1) validation set on top of testing
        % 2) testing
        % 3) validation set below testing
        
        valIndexSetStart1{iterationNumber} = 1;
        valIndexSetEnd1{iterationNumber} = (currentIndex - 1);
        
        
        testIndexSetStart{iterationNumber} = currentIndex;
        testIndexSetEnd{iterationNumber} = testingSetSize;
  
        
        valIndexSetStart2{iterationNumber} = (testingSetSize + 1);
        valIndexSetEnd2{iterationNumber} = numberOfExamples;
        
%         disp(iterationNumber);
%         st = sprintf('ValIndexSetStart1: %d', valIndexSetStart1{iterationNumber});
%         disp(st);
%         st = sprintf('ValIndexSetEnd1: %d', valIndexSetEnd1{iterationNumber});
%         disp(st);
%         st = sprintf('ValIndexSetStart2: %d', valIndexSetStart2{iterationNumber});
%         disp(st);
%         st = sprintf('ValIndexSetEnd2: %d', valIndexSetEnd2{iterationNumber});
%         disp(st);
%         st = sprintf('TestIndexSetStart: %d', testIndexSetStart{iterationNumber});
%         disp(st);
%         st = sprintf('TestIndexSetEnd: %d', testIndexSetEnd{iterationNumber});
%         disp(st);
%         
        currentIndex = currentIndex + bucketSize;
        iterationNumber = iterationNumber + 1;
    end
    
end

