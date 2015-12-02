% Load x and y from dataset
load('./forstudents/cleandata_students.mat');

% Transpose values into expected format
[x2, y2] = ANNdata(x, y);

% P represents the training input
P = x2;
% T represents the targets
T = y2;

net = feedforwardnet(54, 'traingdm');
net = configure(net, x2, y2);

% To train the ntwork for 100 epochs
net.trainParam.epochs = 100;
net.trainParam.lr = 0.3268;
net.trainParam.mc = 0.5;
[net, tr] = train(net, P, T);

validationPredictions = testANN(net, x);

validationError = sum(validationPredictions ~= y)/size(validationPredictions,1)
