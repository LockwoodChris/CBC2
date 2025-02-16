% Cross validation for the parameter estimation
function [avgTrainingError, avgValidationError, bestNet] = crossValidation(k, x, y, params)
   
    % Transpose values into expected format
    [x2, y2] = ANNdata(x, y);
    
    % vs contains the validation set start indexes (t for training)
    % ve contains the validation set end indexes (t for training)    
    [ts1,te1, ts2, te2, vs, ve] = crossValidationIndexes(k, x, y);
    
    % Architecture configuration
    
    % "Rules of thumb" for choosing architecture
    % Number of neurons
    % Using heuristics
    % heuristic1 = (input neurons + output neurons)* 2/3
    heuristic1 = 34;
    % Never larger than twisce the size of input layer
    heuristic2 = 90;
    % Between input and output layer size (6 and 45) we chose 20
    heuristic3 = 20;
    hunitsPossible = [6, heuristic3, heuristic1, 45];
       
    % Number of hidden layers
    % Not beyond 4 because to hard to train
    nlayerPossible = [1, 2, 3]; % Do 3 seperately
    
    % Number of hidden units combos
    hiddenUnitsAndLayers = combineLayers(nlayerPossible,hunitsPossible);
    % size(hiddenUnitsAndLayers) %used to output limit
    hiddenUnitParam = hiddenUnitsAndLayers{params{1}};
    
    % Different learning algos
    lAlgo = {'traingd','traingda','traingdm','trainrp'};
    trainingFunc = lAlgo{params{2}};
    
    % Default rate is .01
    % usually takes small values, usually between .01 and .1
    gd_lrates = {.01, .05 , .1};
    
    gda_lr_inc_rs = {1.05, 1.1, 1.15};
    gda_lr_dec_rs = {0.5, 0.6, 0.7};
    
    gdm_mcs = {0.85, 0.9, 0.95};
    
    rp_inc = {1.3, 1.2, 1.1};
    rp_dec = {0.6, 0.5, 0.4};
    
    % saves errors over iterations
    validationError = cell(k,1);
    trainingError = cell(k,1);
    % minError for bestNet
    minError = Inf;
    for i = 1:k
        % To create a network with specified learning function and
        % hiddenunits
        net = feedforwardnet(hiddenUnitParam, trainingFunc);
        net = configure(net, x2, y2);
        net.trainParam.showWindow = 0;
        
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
        net.divideParam.testInd  = 1:0;
       
        % Training Params need to be set here:
        net.trainParam.lr = gd_lrates{params{3}};
        if strcmp(trainingFunc,'traingd')
            %net.trainFcn = 'traingd';
        elseif strcmp(trainingFunc, 'traingda')
            %net.trainFcn = 'traingda';
            net.trainParam.lr_inc = gda_lr_inc_rs{params{4}};
            net.trainParam.lr_dec = gda_lr_dec_rs{params{5}}; 
        elseif strcmp(trainingFunc, 'traingdm')
            %net.trainFcn = 'traingdm';
            net.trainParam.mc = gdm_mcs{params{4}};
        else %'trainrp'
            %net.trainFcn = 'trainrp';
            net.trainParam.delt_inc = rp_inc{params{4}}; 
            net.trainParam.delt_dec = rp_dec{params{5}};
        end
        
        
        % To train the ntwork for 100 epochs
        net.trainParam.epochs = 100;
        
        [net, tr] = train(net, x2, y2);
        
        % Training Record outputted stats
        % Best epoch
        %disp(tr.best_epoch);

        % Best performance on training set
        %disp(tr.best_perf);

        % Best performance on validation set
        %disp(tr.best_vperf);
        
        validationPredictions = testANN(net, validationSet);
        trainingPredictions = testANN(net, trainingSet);
        
        validationError{i} = sum(validationPredictions ~= validationLabels)/size(validationPredictions,1);
        trainingError{i} = sum(trainingPredictions ~= trainingLabels)/size(trainingPredictions,1);
        
        % Saves best performing net
        if (minError > validationError{i})
            minError = validationError{i};
            bestNet = net;
        end
        
        %st = sprintf('Validation Error:%d \nTraining Error:%d', validationError{i}*100, trainingError{i}*100);
        %disp(st);
        
    end
    
    avgValidationError = mean(cell2mat(validationError));
    avgTrainingError = mean(cell2mat(trainingError));
end