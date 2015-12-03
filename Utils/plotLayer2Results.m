function [a] = plotLayer2Results(results)
    sizes = cell2mat({11,20,34,45});
    minErrors = cell(size(results,1),1);
    for i = 1:size(results,1)
        [layer1, layer2, layer3] = divideResultsInLayers(results{i,4});
        minErrors{i} = cell2mat(findMinErrorInLayer2(layer2));
    end
    for i = 1:size(results,1)
        figure;
        surf(sizes, sizes, minErrors{i});
    end
end

function [minErrors] = findMinErrorInLayer2(layer2)
    minErrors = cell(4,4);
    for m = 1:4
        for i = 1:4
            minError = 1;
            for lr = 1:3
                for ilr = 1:3
                    for dlr = 1:3
                       if (layer2{m*i,lr,ilr,dlr} < minError)
                           minError = layer2{m*i,lr,ilr,dlr};
                       end
                    end
                end
            end
            minErrors{m,i} = minError;
        end
    end
end