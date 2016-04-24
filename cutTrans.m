function [ cut ] = cutTrans( trans )
% Cut transmission to 0.1-1
    [height, width, nch] = size(trans);
    for i = 1:1:height
        for j = 1:1:width
            if trans(i, j) == -1
                continue;
            elseif trans(i, j) < 0.1
                trans(i, j) = 0.1;
            elseif trans(i, j) > 1
                trans(i, j) = 1;
            end
        end
    end
    cut = trans;
end

