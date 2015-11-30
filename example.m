% P represents the training input
P = 0:0.01:1;
% T represents the targets
T = sin(-pi/2 + P * 3 * pi);

% To create a network with one hidden layer and five neurons 
net = feedforwardnet(5);
net = configure(net, P, T);

% To train the ntwork for 100 epochs, and plot the output
net.trainParam.epochs = 100;
net = train(net, P, T);
Y = sim(net, P);
plot(P, T, P, Y, 'r.');