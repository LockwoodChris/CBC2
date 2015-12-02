% Cross validation for the parameter estimation

% Questions
% 1. How do we extract data from the training of the network? It gives us
% some results in GUI form like % error 
% 2. At the bottom of the crossValidation function, we try to calculate the
% validation and classification error ourselves, however this is very
% different from the ones shown in the GUI, have we calculated something
% wrong?
% 3. Parameter estimation: How do we chose the ranges for the values we
% want to test? We were planning on using the default values and then using
% a percentage testing a range before and after the default
% 4. Are we using divideind correctly to divide up our dataset?

function [] = crossValidation(k, x, y)
   
    % Transpose values into expected format
    [x2, y2] = ANNdata(x, y);
    
    % vs contains the validation set start indexes (t for training)
    % ve contains the validation set end indexes (t for training)    
    [ts1,te1, ts2, te2, vs, ve] = crossValidationIndexes(k, x, y);
    
    % saves nets for the iterations
    nets = cell(k,1);
    % saves training record for the  net
    tr = cell(k,1);
    % saves errors over iterations
    validationError = cell(k,1);
    trainingError = cell(k,1);
    for i = 1:k
        % To create a network with one hidden layer and five neurons 
        net = feedforwardnet(5);
        net = configure(net, x2, y2);
        
        % To use our indices
        net.divideFcn = 'divideind';
        
        % Subsets of x used for training and validation
        validationSet = x(vs{i}:ve{i}, :);
        validationLabels = y(vs{i}:ve{i}, :);
        
        trainingSet = x([ts1{i}:te1{i} ts2{i}:te2{i}],:);
        trainingLabels = y([ts1{i}:te1{i} ts2{i}:te2{i}],:);
        
        % Use indices specified previously
        net.divideParam.trainInd = [ts1{i}:te1{i} ts2{i}:te2{i}];
        net.divideParam.valInd   = [vs{i}:ve{i}];
        net.divideParam.testInd   = 1:0;
        
%         st = sprintf('TrainInd: %d:%d, %d:%d', ts1{i}, te1{i}, ts2{i}, te2{i});
%         disp(st);
%         st = sprintf('ValInd: %d:%d', vs{i}, ve{i});
%         disp(st);

        % To train the ntwork for 100 epochs
        net.trainParam.epochs = 100;
        
        [nets{i}, tr{i}] = train(net, x2, y2);
        
        % Training Record outputted stats
        % Best epoch
        disp(tr{i}.best_epoch);

        % Best performance on training set
        disp(tr{i}.best_perf);

        % Best performance on validation set
        disp(tr{i}.best_vperf);
        
        validationPredictions = testANN(net, validationSet);
        trainingPredictions = testANN(net, trainingSet);
        
        validationError{i} = sum(validationPredictions ~= validationLabels)/size(validationPredictions,1);
        trainingError{i} = sum(trainingPredictions ~= trainingLabels)/size(trainingPredictions,1);
        st = sprintf('Validation Error:%d \n Training Error:%d', validationError{i}*100, trainingError{i}*100);
        disp(st);
        
    end

end