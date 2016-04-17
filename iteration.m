function [transmission] = iteration(trans, input)
%
%
    [A, B] = sparse_value(trans, input);
    X = bicg(A, B);
    n = 1;
    transmission = trans;
    [height, width] = size(input);
    width = width / 3;
    for i = 1:1:height
        for j = 1:1:width
            if trans(i, j) == -1
                transmission(i,j) = X(n, 1);
                n = n + 1;
            end
        end
    end
end

function [A, B] = sparse_value(trans, input)
%SPARSE Summary of this function goes here
%   Detailed explanation goes here
    [height, width] = size(input);
    width = width / 3;
    A = sparse(height * width, height * width);
    B = sparse(height * width, 1);
    for i =  1:1:height
        for j = 1:1:width
            if trans(i, j) == -1
                [center, left, right, up, down, b] = calcData_sparse(trans, input, i, j);
                A((i - 1) * width + j, (i - 1) * width + j) = center;
                if ~(left == 0)
                    A((i - 1) * width + j, (i - 1) * width + j - 1) = left;
                end
                if ~(right == 0)
                    A((i - 1) * width + j, (i - 1) * width + j + 1) = right;
                end
                if ~(up == 0)
                    A((i - 1) * width + j, (i - 2) * width + j) = up;
                end
                if ~(down == 0)
                    A((i - 1) * width + j, i * width + j) = down;
                end
                if ~(b == 0)
                    B((i - 1) * width + j, 1) = b;
                end
            end
        end
    end
end


function [center, left, right, up, down, b] = calcData_sparse(transmission, input, i, j)
%
%
    center = 0;
    left = 0;
    right = 0;
    up = 0;
    down = 0;
    b = 0;
    [height, width] = size(input);
    width = width / 3;
    if i - 1 >= 1 % up
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i-1,j,1) input(i-1,j,2) input(i-1,j,3)];
        if norm(vecX-vecY) == 0
            n = 0.001;
        else
            n = norm(vecX-vecY);
        end
        center = center +  1 / n^2;
        if transmission(i-1,j) == -1
            up = -1/ n^2;
        else
            up = 0;
            b = b + transmission(i-1,j) / n^2;
        end
    end

    if i + 1 <= height % down
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i+1,j,1) input(i+1,j,2) input(i+1,j,3)];
         if norm(vecX-vecY) == 0
            n = 0.001;
        else
            n = norm(vecX-vecY);
         end
        center = center +  1 / n^2;
        if transmission(i+1,j) == -1
            down = -1/ n^2;
        else
            down = 0;
            b = b + transmission(i+1,j) / n^2;
        end
    end

    if j - 1 >= 1 % left
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i,j-1,1) input(i,j-1,2) input(i,j-1,3)];
         if norm(vecX-vecY) == 0
            n = 0.001;
        else
            n = norm(vecX-vecY);
        end
        center = center +  1 / n^2;
        if transmission(i,j-1) == -1
            left = -1/ n^2;
        else
            left = 0;
            b = b + transmission(i,j-1) / n^2;
        end
    end

    if j + 1 <= width % right
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i,j+1,1) input(i,j+1,2) input(i,j+1,3)];
        if norm(vecX-vecY) == 0
            n = 0.001;
        else
            n = norm(vecX-vecY);
        end
        center = center +  1 / n^2;
        if transmission(i,j + 1) == -1
            right = -1/ n^2;
        else
            right = 0;
            b = b + transmission(i,j + 1) / n^2;
        end
    end
end

%function [transmission] = iteration(trans, input)
%
%
%    [height, width] = size(input);
%    width = width / 3;
%    transmission = trans;
%    for i = 1:1:height
%        for j = 1:1:width
%            if trans(i, j) == -1
%                transmission(i,j) = 0;
%            end
%        end
%    end
%    diff = 100;
%    while diff > 0.00001
%        diff = 0;
%        for i = 1:1:height
%            for j = 1:1:width
%                if ~(trans(i, j) == -1)
%                    continue;
%                end
%                newData = calcData(transmission, input, i, j);
%                diff = diff + abs(newData - transmission(i,j));
%                transmission(i,j) = newData;
%            end
%        end
%    end
%end

function [newData] = calcData(transmission, input, i, j)
%
%
    data = 0;
    sum = 0;
    [height, width] = size(input);
    width = width / 3;
    if i - 1 >= 1
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i-1,j,1) input(i-1,j,2) input(i-1,j,3)];
        if norm(vecX-vecY) == 0
            n = 0.001;
        else
            n = norm(vecX-vecY);
        end
        data = data + transmission(i-1,j) / n^2;
        sum = sum + 1/norm(vecX-vecY)^2;
    end

    if i + 1 <= height
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i+1,j,1) input(i+1,j,2) input(i+1,j,3)];
         if norm(vecX-vecY) == 0
            n = 0.001;
        else
            n = norm(vecX-vecY);
        end
        data = data + transmission(i+1,j) / n^2;
        sum = sum + 1/norm(vecX-vecY)^2;
    end

    if j - 1 >= 1
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i,j-1,1) input(i,j-1,2) input(i,j-1,3)];
         if norm(vecX-vecY) == 0
            n = 0.001;
        else
            n = norm(vecX-vecY);
        end
        data = data + transmission(i,j-1) / n^2;
        sum = sum + 1/norm(vecX-vecY)^2;
    end

    if j + 1 <= width
        vecX = [input(i,j,1) input(i,j,2) input(i, j,3)];
        vecY = [input(i,j+1,1) input(i,j+1,2) input(i,j+1,3)];
         if norm(vecX-vecY) == 0
            n = 0.001;
        else
            n = norm(vecX-vecY);
        end
        data = data + transmission(i,j+1) / n^2;
        sum = sum + 1/norm(vecX-vecY)^2;
    end

    newData = data / sum;
end