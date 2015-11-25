function [predictions] = testTrees(trees, x2)
    n = size(x2, 1);
    predictions = zeros(n,1);
    for i = 1:n
        results = zeros(size(trees, 2), 2);
        for j = 1:(size(trees, 2))
            [results(j,1), results(j,2)] = testTree(trees{j}, x2(i,:));
        end
        predictions(i) = chooseResult(results);
    end
end

function [result, depth] = testTree(tree, attributes)
    depth = 0;
    if (isfield(tree, 'class'))
        result = tree.class;
    elseif (attributes(tree.op) == 1)
        [result, depth1] = testTree(tree.kids{2}, attributes);
        depth = depth1 + 1;
    else
        [result, depth1] = testTree(tree.kids{1}, attributes);
        depth = depth1 + 1;
    end
end

function [curr_emotion] = chooseResult(results)
    match_found = 0;
    curr_emotion = 0;
    max_depth = 0;
    for j = 1:size(results, 1)
        if match_found == 1
            if results(j, 1) == 1
                if results(j, 2) <= max_depth
                    max_depth    = results(j,2);
                    curr_emotion = j;
                end
            end
        else
            if results(j, 1) == 1
                match_found   = 1;
                curr_emotion  = j;
                max_depth     = results(j,2);
            else
                if results(j, 2) >= max_depth
                    max_depth    = results(j,2);
                    curr_emotion = j;
                end
            end
        end
    end
end

function [curr_emotion] = chooseRandomResult(results)
    emotions = [];
    i = 1;
    for j = 1:size(results, 1)
        if results(j, 1) == 1
            emotions(i) = j;
            i = i + 1;
        end
    end
    if (isempty(emotions))
        curr_emotion = 1 + floor(rand() * 6);
    else
        curr_emotion = emotions(1 + floor(rand()*length(emotions)));
    end
end