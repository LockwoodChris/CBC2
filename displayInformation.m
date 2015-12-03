function [] = displayInformation(results)

    params = results{2};
    
    disp(params(1));
    hiddenConfig = unfoldConfig(params{1});
    
    disp(params);
    
    
    
    s = sprintf('number of layers: %d', length(hiddenConfig));
    disp(s);
    % Displays the number of layers and their neurons
    for i = 1:length(hiddenConfig)
       s = sprintf('num neurons in layer %d: %d', i, hiddenConfig(i));
       disp(s);
    end
    
    s = sprintf('best error %d:', results{3});
    disp(s);
    
    % Finds average error
    
    
end