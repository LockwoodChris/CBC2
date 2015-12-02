function [layer1, layer2, layer3] = divideResultsInLayers(results)
    if length(results) == 84
        layer1 = cell(4, 3, 3);
        layer2 = cell(16, 3, 3);
        layer3 = cell(64, 3, 3);
        for i=1:84
            for j=1:3
                for k=1:3
                    if i < 5
                        layer1{i,j,k} = results{i,j,k};
                    elseif i < 21
                        layer2{i-4,j,k} = results{i,j,k};
                    else
                        layer3{i-20,j,k} = results{i,j,k};
                    end
                end
            end
        end
    end
end