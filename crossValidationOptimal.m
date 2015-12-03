function [errors] = crossValidationOptimal(k, x, y, bestConfigs)
   
    % vs contains the validation set start indexes (t for training)
    % ve contains the validation set end indexes (t for training)    
    [ts1,te1, ts2, te2, vs, ve] = crossValidationIndexes(k, x, y);
    
    nlayerPossible = [1, 2, 3];
    hunitsPossible = [11, 20, 34, 45];
    
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
    
    hiddenUnitsAndLayers = combineLayers(nlayerPossible,hunitsPossible);
    
    lAlgo = {'traingd','traingda','traingdm','trainrp'};
       
    errors = zeros(k,1);
    
    for i = 1:k
        params = bestConfigs{k};
        funcId = params(2);
        % Setting the training data for the fold
        trainData = x([ts1{i}:te1{i} ts2{i}:te2{i}], :);
        trainLabels = y([ts1{i}:te1{i} ts2{i}:te2{i}], :);
        
        testData = x(vs{i}:ve{i}, :);
        testLabels = y(vs{i}:ve{i}, :);
        
        [trainData2, trainLabels2] = ANNdata(trainData, trainLabels);
        
        net = feedforwardnet(hiddenUnitsAndLayers{params(1)},lAlgo{funcId});
        net = configure(net, trainData2, trainLabels2);
        net.trainParam.showWindow = 0;
        net.trainParam.epochs = 100;
        net.divideFcn = 'divideint';
        net.divideParam.trainRatio = .89;
        net.divideParam.valRatio = .11;
        net.divideParam.testRatio = 0.0;
        
        switch funcId
            case 1
                % Gradient Descent normal case
                net.trainParam.lr = gd_lrates{params(3)};
                %%%
                [net, tr] = train(net, trainData2, trainLabels2);
                testPredictions = testANN(net, testData);
                error = sum(testPredictions ~= testLabels)/size(testPredictions,1);
                errors(k) = error;
            case 2
                % Gradient Descent A
                net.trainParam.lr = gda_lrates{params(3)};
                net.trainParam.lr_inc = gda_lr_inc_rs{params(4)};
                net.trainParam.lr_dec = gda_lr_dec_rs{params(5)}; 
                [net, tr] = train(net, trainData2, trainLabels2);
                testPredictions = testANN(net, testData);
                error = sum(testPredictions ~= testLabels)/size(testPredictions,1);
                errors(k) = error;
            case 3
                % Gradient Descent M
                net.trainParam.lr = gdm_lrates{params(3)};
                net.trainParam.mc = gdm_mcs{params(4)};
                %%%
                [net, tr] = train(net, trainData2, trainLabels2);
                testPredictions = testANN(net, testData);
                error = sum(testPredictions ~= testLabels)/size(testPredictions,1);
                errors(k) = error;
            otherwise
                % Resillient
                net.trainParam.lr = rp_lrates{params(3)};
                net.trainParam.delt_inc = rp_inc{params(4)};
                net.trainParam.delt_dec = rp_dec{params(5)}; 
                %%%
                [net, tr] = train(net, trainData2, trainLabels2);
                testPredictions = testANN(net, testData);
                error = sum(testPredictions ~= testLabels)/size(testPredictions,1);
                errors(k) = error;
        end
    end
    disp(errors);
end