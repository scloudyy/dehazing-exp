function [roughTans] = calcTransmission(inputimg, A)
%
%
    [height, width] = size(inputimg);
    width = width / 3;
    trans = zeros(height, width);
    for i = 4:3:height-4
        for j = 4:3:width-4
            p = inputimg(i-3:i+3, j-3:j+3, :);
            [D, V, mask] = calcColorLine(p, A);
            if sum(sum(mask)) == 0
                continue;
            else
                x = calcT(D, V, A);
                s = x(2,1);
                if s >=0 && s <= 1
                    mask = mask*s;
                    trans(i-3:i+3, j-3:j+3) = mask;
                end
            end
        end
    end
    roughTans = trans;
end

function [x] = calcT(D, V, A)
    vecD = [D(:,:,1) D(:,:,2) D(:,:,3)];
    vecV = [V(:,:,1) V(:,:,2) V(:,:,3)];
    matA = [norm(vecD) -dot(A,vecD); -dot(A,vecD) norm(A)];
    matB = [-dot(vecD,vecV); dot(A,vecV)];
    x = matA \ matB;
end