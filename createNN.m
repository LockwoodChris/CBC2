% hidden_layers = number of neurons per hidden layer
% trainAlg = one of the algorithms from set:
%     ['traingd','trainlm','traingda','trainrp','traingdm']
% x = inputs, y = targets
% returns predictions = prediction of labels (6x1004)
function [predictions] = createNN(hidden_layers, x, y, trainAlg, numEpoches, withPlots)
   net = feedforwardnet(hidden_layers, trainAlg);
   net = configure(net, x, y);
   net.trainParam.epochs = numEpoches;
   [net, tr] = train(net, x, y);
   predictions = sim(net, x);
   if withPlots == true
       plotregression(y, predictions); figure;
       plotconfusion(y, predictions); figure;
       ploterrhist(predictions - y, 'bins', 30); figure;
       plotperform(tr); figure;
       plotroc(y, predictions); figure;
       plottrainstate(tr);
   end
end
