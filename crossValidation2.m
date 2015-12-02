% Cross validation for the parameter estimation
% Second parameter estimation for more specific configurations
function [avgTrainingError, avgValidationError, bestNet] = crossValidation2(k, x, y, params)
   
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
    hunitsPossible = [11, heuristic3, heuristic1, 45];
       
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
    
    % First run had better results with higher learning rate
    gd_lrates = {.1, .3, .5}; 
    
    % First results had best results towards lower inc/dec 
    % best lrate was .05
    gda_lrates = {.02, .05, .07}; 
    gda_lr_inc_rs = {.20, .6, 1};
    gda_lr_dec_rs = {.1, .3, 0.5};
    
    % First runs were very bad exploring outside old space
    % Best learning was 3 so we slide our window
    gdm_lrates = {.1, .3, .5};
    gdm_mcs = {.3, .55, .80};
    
    % Based on first run values
    rp_lrates = {.005, .01, .015};
    rp_inc = {1.7, 1.5, 1.3};
    rp_dec = {.55, .5, .45};
    
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
        
        if strcmp(trainingFunc,'traingd')
            net.trainParam.lr = gd_lrates{params{3}};
            %net.trainFcn = 'traingd';
        elseif strcmp(trainingFunc, 'traingda')
            %net.trainFcn = 'traingda';
            net.trainParam.lr = gda_lrates{params{3}};
            net.trainParam.lr_inc = gda_lr_inc_rs{params{4}};
            net.trainParam.lr_dec = gda_lr_dec_rs{params{5}}; 
        elseif strcmp(trainingFunc, 'traingdm')
            %net.trainFcn = 'traingdm';
            net.trainParam.lr = gdm_lrates{params{3}};
            net.trainParam.mc = gdm_mcs{params{4}};
        else %'trainrp'
            %net.trainFcn = 'trainrp';
            net.trainParam.lr = rp_lrates{params{3}};
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