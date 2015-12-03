% Cross validation for the parameter evaluation
% 
function [bestNets, bestErrors, bestConfig] = crossValidationEvaluation(k, x, y)
   
    % vs contains the validation set start indexes (t for training)
    % ve contains the validation set end indexes (t for training)    
    [ts1,te1, ts2, te2, vs, ve] = crossValidationIndexes(k, x, y);
    
    % Architecture configuration
    % "Rules of thumb" for choosing architecture
    % Number of neurons
    % Using heuristics
    % heuristic1 = (input neurons + output neurons)* 2/3
    heuristic1 = 34;
    % Between input and output layer size (6 and 45) we chose 20
    heuristic3 = 20;
    hunitsPossible = [11, heuristic3, heuristic1, 45];
       
    % Number of hidden layers
    % Not beyond 4 because to hard to train
    nlayerPossible = [1, 2, 3];
    
    % Number of hidden units combos
    hiddenUnitsAndLayers = combineLayers(nlayerPossible,hunitsPossible);

    
    % Different learning algos
    lAlgo = {'traingd','traingda','traingdm','trainrp'};
    
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

    
    % minError for bestNet
    bestNets = cell(k,1);
    bestErrors = num2cell(zeros(k,1) + inf);
    bestConfig = cell(k, 1);
    
    for i = 2:2
        % Setting the training data for the fold
        trainData = x([ts1{i}:te1{i} ts2{i}:te2{i}], :);
        trainLabels = y([ts1{i}:te1{i} ts2{i}:te2{i}], :);
        
        testData = x(vs{i}:ve{i}, :);
        testLabels = y(vs{i}:ve{i}, :);
        
        [trainData2, trainLabels2] = ANNdata(trainData, trainLabels);
        
        % Loop over different topologies
        for topIndex = 1:84
            % Choosing function
            for funcId = 1:4 
               net = feedforwardnet(hiddenUnitsAndLayers{topIndex},lAlgo{funcId});
               net = configure(net, trainData2, trainLabels2);
               net.trainParam.showWindow = 0;
               net.trainParam.epochs = 100;
               net.divideFcn = 'divideint';
               net.divideParam.trainRatio = .89;
               net.divideParam.valRatio = .11;
               net.divideParam.testRatio = 0.0;
               
               % learning rate
                for j = 1:3
                    fprintf('Iteration Index: %d, %d, %d, %d \n', i, topIndex, funcId, j);
                    switch funcId
                        case 1
                            % Gradient Descent normal case
                            net.trainParam.lr = gd_lrates{j};
                            %%%
                            [net, tr] = train(net, trainData2, trainLabels2);
                            testPredictions = testANN(net, testData);
                            error = sum(testPredictions ~= testLabels)/size(testPredictions,1);
                            if(bestErrors{i} > error)
                                bestErrors{i} = error;
                                bestNets{i} = net;
                                bestConfig{i} = [topIndex, funcId, j];
                            end
                            
                        case 2
                            % Gradient Descent A
                            net.trainParam.lr = gda_lrates{j};
                            for m = 1:3 % adaptive increase rate
                                net.trainParam.lr_inc = gda_lr_inc_rs{m};
                                for p = 1:3 % adaptive decrease rate
                                    net.trainParam.lr_dec = gda_lr_dec_rs{p}; 
                                    %%%
                                    [net, tr] = train(net, trainData2, trainLabels2);
                                    testPredictions = testANN(net, testData);
                                    error = sum(testPredictions ~= testLabels)/size(testPredictions,1);
                                    if(bestErrors{i} > error)
                                        bestErrors{i} = error;
                                        bestNets{i} = net;
                                        bestConfig{i} = [topIndex, funcId, j, m, p];
                                    end
                                end
                            end
                        case 3
                            % Gradient Descent M
                            net.trainParam.lr = gdm_lrates{j};
                            for m = 1:3 % mc
                                net.trainParam.mc = gdm_mcs{m};
                                %%%
                                [net, tr] = train(net, trainData2, trainLabels2);
                                testPredictions = testANN(net, testData);
                                error = sum(testPredictions ~= testLabels)/size(testPredictions,1);
                                if(bestErrors{i} > error)
                                    bestErrors{i} = error;
                                    bestNets{i} = net;
                                    bestConfig{i} = [topIndex, funcId, j, m];
                                end
                            end
                        otherwise
                            % Resillient
                            net.trainParam.lr = rp_lrates{j};
                            for m = 1:3 % delta inc
                                net.trainParam.delt_inc = rp_inc{m};
                                for p = 1:3 % delta dec
                                    net.trainParam.delt_dec = rp_dec{p}; 
                                    %%%
                                    [net, tr] = train(net, trainData2, trainLabels2);
                                    testPredictions = testANN(net, testData);
                                    error = sum(testPredictions ~= testLabels)/size(testPredictions,1);
                                    if(bestErrors{i} > error)
                                        bestErrors{i} = error;
                                        bestNets{i} = net;
                                        bestConfig{i} = [topIndex, funcId, j, m, p];
                                    end
                                end
                            end
                    end
                end
            end
        end
        
    end
    
end
