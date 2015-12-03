% results = [gdaresults, respresults, ...etc.]
function [a] = plotLayer1Results(results)
    sizes = cell2mat({ 11; 20; 34; 45});
    minErrors = cell(1,4);
    for i = 1:size(results,1)
        [layer1, layer2, layer3] = divideResultsInLayers(results{i,4});
        minErrors{1,i} = cell2mat(findMinErrorInCube(layer1));
    end
    plot(sizes, cell2mat(minErrors));
end

% 4d shape = i x 3 x 3 x 3
function minErrors = findMinErrorInCube(cube)
    minErrors = cell(4,1);
    for i = 1:size(cube,1)
        minError = 1;
        for lr = 1:3
            for ilr = 1:3
                for dlr = 1:3
                   if (cube{i,lr,ilr,dlr} < minError)
                       minError = cube{i,lr,ilr,dlr};
                   end
                end
            end
        end
        minErrors{i} = minError;
    end
end