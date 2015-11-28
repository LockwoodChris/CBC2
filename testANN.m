% net = a neural net (e.g. net = feedforwardnet(5)
% examples = input examples (x)
% returns NN prediction (1004x1)
function predictions = testANN(net, examples)
   load('.\forstudents\cleandata_students.mat','y');
   [examples, y] = ANNdata(examples, y);
   net = configure(net, examples, y);
   net.trainParam.epochs = 1000;
   net = train(net, examples, y);
   predictions = sim(net, examples);
   predictions = NNout2labels(predictions);
end