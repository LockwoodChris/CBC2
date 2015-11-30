% Load x and y from dataset
load('./forstudents/cleandata_students.mat');

% Transpose values into expected format
[x2, y2] = ANNdata(x, y);

% P represents the training input
P = x2;
% T represents the targets
T = y2;

% To create a network with one hidden layer and five neurons 
net = feedforwardnet(20);
net = configure(net, P, T);

% To train the ntwork for 100 epochs, and plot the output
net.trainParam.epochs = 100;
net = train(net, P, T);

% Simulate nn
% Y = sim(net, P);

Y = testANN(net, x);

Y
%plot(P, T, P, Y, 'r.');