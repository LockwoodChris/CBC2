% Cross validation for the parameter estimation

function [] = crossValidation(k, x, y)
   
    % Transpose values into expected format
    [x2, y2] = ANNdata(x, y);

    % P represents the training input
    P = x2;
    % T represents the targets
    T = y2;
    
    % vs contains the validation set start indexes (t for test)
    % ve contains the validation set end indexes (t for test)    
    [vs1,ve1, vs2, ve2, ts, te] = crossValidationIndexes(k, x, y);
    
    % saves nets for the iterations
    nets = cell(k,1);
    % saves best training record for the  net
    tr = cell(k,1);
    
    for i = 1:k
        % To create a network with one hidden layer and five neurons 
        net = feedforwardnet(5);
        net = configure(net, P, T);
        
        % To use our indices
        net.divideFcn = 'divideind';
        
        % Use indices specified previously
        net.divideParam.trainInd = [vs1{i}:ve1{i} vs2{i}:ve2{i}];
        net.divideParam.valInd   = [ts{i}:te{i}];
        net.divideParam.testInd   = 1:0;
        
        st = sprintf('TrainInd: %d:%d, %d:%d', vs1{i}, ve1{i}, vs2{i}, ve2{i});
        disp(st);
        st = sprintf('ValInd: %d:%d', ts{i}, te{i});
        disp(st);

        % To train the ntwork for 100 epochs, and plot the output
        net.trainParam.epochs = 100;
        
        [nets{i}, tr{i}] = traingd(net, P, T);

        % Best epoch
        disp(tr{i}.lr);

        % Best performance on training set
        disp(tr{i}.best_perf);

        % Best performance on validation set
        disp(tr{i}.best_vperf);

    end

end