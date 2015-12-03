function [layer1, layer2, layer3] = divideResultsInLayers(results)
    size_ = length(size(results));
    if (size_==2)
        [layer1, layer2, layer3] = divide2dResultsInLayers(results);
    elseif (size_==3)
        [layer1, layer2, layer3] = divide3dResultsInLayers(results); 
    else
        [layer1, layer2, layer3] = divide4dResultsInLayers(results);
    end
end

function [layer1, layer2, layer3] = divide4dResultsInLayers(results)
    if length(results) == 84
        layer1 = cell(4, 3, 3, 3);
        layer2 = cell(16, 3, 3, 3);
        layer3 = cell(64, 3, 3, 3);
        for i=1:84
            for j=1:3
                for k=1:3
                    for m=1:3
                        if i < 5
                            layer1{i,j,k,m} = results{i,j,k,m};
                        elseif i < 21
                            layer2{i-4,j,k,m} = results{i,j,k,m};
                        else
                            layer3{i-20,j,k,m} = results{i,j,k,m};
                        end
                    end
                end
            end
        end
    end
end

function [layer1, layer2, layer3] = divide3dResultsInLayers(results)
    if length(results) == 84
        layer1 = cell(4, 3, 3, 3);
        layer2 = cell(16, 3, 3, 3);
        layer3 = cell(64, 3, 3, 3);
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

function [layer1, layer2, layer3] = divide2dResultsInLayers(results)
    if length(results) == 84
        layer1 = cell(4, 3, 3, 3);
        layer2 = cell(16, 3, 3, 3);
        layer3 = cell(64, 3, 3, 3);
        for i=1:84
            for j=1:3
                if i < 5
                    layer1{i,j} = results{i,j};
                elseif i < 21
                    layer2{i-4,j} = results{i,j};
                else
                    layer3{i-20,j} = results{i,j};
                end
            end
        end
    end
end