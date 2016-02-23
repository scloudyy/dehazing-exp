function [transmission] = iteration(trans, input)
%
%
    [height, width] = size(input);
    width = width / 3;
    transmission = trans;
    diff = 100;
    while diff > 0.01
        diff = 0;
        for i = 1:1:height
            for j = 1:1:width
                if ~(trans(i, j) == 0)
                    continue;
                end
                newData = calcData(transmission, input, i, j);
                diff = diff + abs(newData - transmission(i,j));
                transmission(i,j) = newData;
            end
        end
    end
end

function [newData] = calcData(transmission, input, i, j)
%
%
    data = 0;
    sum = 0;
    if i - 1 >= 1
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i-1,j,1) input(i-1,j,2) input(i-1,j,3)];
        data = data + transmission(i-1,j) / norm(vecX,vecY)^2;
        sum = sum + 1;
    end

    if i + 1 >= 1
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i+1,j,1) input(i+1,j,2) input(i+1,j,3)];
        data = data + transmission(i+1,j) / norm(vecX,vecY)^2;
        sum = sum + 1;
    end

    if j - 1 >= 1
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i,j-1,1) input(i,j-1,2) input(i,j-1,3)];
        data = data + transmission(i,j-1) / norm(vecX,vecY)^2;
        sum = sum + 1;
    end

    if j + 1 >= 1
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i,j+1,1) input(i,j+1,2) input(i,j+1,3)];
        data = data + transmission(i,j+1) / norm(vecX,vecY)^2;
        sum = sum + 1;
    end

    newData = data / sum;
end