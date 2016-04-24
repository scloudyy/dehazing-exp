function [ T ] = calcRestructT( A, B, height, width, fileNames )
% Use bicg to resolve AX=B, and T is from X
    T = zeros(height, width);
    Show = zeros(height, width, 3);
    X = bicg(A, B, 1e-16, 10000);
    sum = 1;
    for i = 1:1:height
        for j = 1:1:width
            v = X(sum, 1);
            if v < 0.1
                v = 0.1;
            elseif v  > 1
                v = 1;
            end
            T(i, j) = v;
            Show(i, j, :) = 255 * v;
            sum = sum + 1;
        end
    end
    imwrite(uint8(Show), char(strcat('Result\', fileNames, '_restructT.bmp')));
end

