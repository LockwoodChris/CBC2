function [error_rate] = classificationError(x, y)
    error_rate = (1/length(y))*sum(x~=y);
end