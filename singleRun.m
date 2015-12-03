% Cross validation for the parameter estimation
% Second parameter estimation for more specific configurations
function [testPredictions, testError] = singleRun(trainData, trainLabels, testData, testLabels, params)
   
    % Transpose values into expected format
    [trainData2, trainLabels2] = ANNdata(trainData, trainLabels);
    
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
    gda_lr_inc_rs = {1.05, 1.1, 1.15};
    gda_lr_dec_rs = {.1, .3, 0.5};
    
    % First runs were very bad exploring outside old space
    % Best learning was 3 so we slide our window
    gdm_lrates = {.1, .3, .5};
    gdm_mcs = {.3, .55, .80};
    
    % Based on first run values
    rp_lrates = {.005, .01, .015};
    rp_inc = {1.7, 1.5, 1.3};
    rp_dec = {.55, .5, .45};

    % To create a network with specified learning function and
    % hiddenunits
    net = feedforwardnet(hiddenUnitParam, trainingFunc);
    net = configure(net, trainData2, trainLabels2);
    net.trainParam.showWindow = 0;

    net.divideFcn = 'divideint';
    net.divideParam.trainRatio = .89;
    net.divideParam.valRatio = .11;
    net.divideParam.testRatio = 0.0;

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
    [net, ~] = train(net, trainData2, trainLabels2);

    testPredictions = testANN(net, testData);
    testError = sum(testPredictions ~= testLabels)/size(testLabels, 1);

    %st = sprintf('Validation Error:%d \nTraining Error:%d', validationError{i}*100, trainingError{i}*100);
    %disp(st);

end