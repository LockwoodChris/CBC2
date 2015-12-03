function config = unfoldConfig(index)
    nlayerPossible = [1, 2, 3];
    heuristic1 = 34;
    % Never larger than twisce the size of input layer
    heuristic2 = 90;
    % Between input and output layer size (6 and 45) we chose 20
    heuristic3 = 20;
    hunitsPossible = [6, heuristic3, heuristic1, 45];
    hiddenUnitsAndLayers = combineLayers(nlayerPossible,hunitsPossible);
    config = hiddenUnitsAndLayers{index};
end