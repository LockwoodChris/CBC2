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

% To train the ntwork for 100 epochs
net.trainParam.epochs = 100;
[net, tr] = train(net, P, T);

% Best epoch
disp(tr.best_epoch);

% Best performance on training set
disp(tr.best_perf);

% Best performance on validation set
disp(tr.best_vperf);


%plot(P, T, P, Y, 'r.');