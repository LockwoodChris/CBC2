% net = a neural net (e.g. net = feedforwardnet(5)
% examples = input examples (x)
% returns NN prediction (1004x1)
function prediction_labels = testANN(net, examples)
   
   predictions = sim(net, examples.');
   prediction_labels = NNout2labels(predictions);
end