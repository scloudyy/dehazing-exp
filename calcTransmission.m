function [roughTans] = calcTransmission(inputimg, A)
%
%
    [height, width] = size(inputimg);
    width = width / 3;
    trans = zeros(height, width);
    gray = rgb2gray(inputimg);
    edges = edge(gray, 'canny');
    for i = 4:3:height-4
        for j = 4:3:width-4
            if sum(sum(edges(i-3:i+3, j-3:j+3))) >= 5
                continue;
            end
            p = inputimg(i-3:i+3, j-3:j+3, :);
            [D, V, mask] = calcColorLine(p, A);
            if sum(sum(mask)) == 0
                continue;
            else
                x = calcT(D, V, A);
                s = x(2,1);
                isValid = calcValid(D, V, A, x, p, mask);
                if isValid == 1
                    mask = mask * (1 -s);
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

function [isValid] = calcValid(D, V, A, x, p, mask)
l = x(1,1);
s = x(2,1);
if s < 0 || s >1
    isValid = 0;
    return;
end
vecD = [D(:,:,1) D(:,:,2) D(:,:,3)];
vecV = [V(:,:,1) V(:,:,2) V(:,:,3)];
vecA = A;
x1 = l * vecD + vecV;
x2 = s * vecA;
dis = norm(x1-x2);
if dis > 0.6
    isValid = 0;
    return;
end

vecVar = [];
for i = 1:1:7
    for j = 1:1:7
        if mask(i, j) == 1
            vecTmp = [p(i,j,1) p(i,j,2) p(i, j, 3)];
            vecVar = [vecVar dot(vecTmp-vecV, vecD)];
        end
    end
end
if std(vecVar) / (1-s) < 0.02
    isValid = 0;
    return;
end

isValid = 1;
end
