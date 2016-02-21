function [D, V, mask] = calcColorLine(p, A)
%
%
maxVote = -1;
times = 0;
while times <= 30
    x = floor(1 + (7 - 1) * rand(1, 1));
    y = floor(1 + (7 - 1) * rand(1, 1));
    x1 = p(y, x, :);

    x = floor(1 + (7 - 1) * rand(1, 1));
    y = floor(1 + (7 - 1) * rand(1, 1));
    x2 = p(y, x, :);

    tmpD = x2 - x1;
    vectmpD = [tmpD(:,:,1) tmpD(:,:,2) tmpD(:,:,3)];
    if norm(vectmpD, 1) == 0
        times = times + 0.5;
        continue;
    end
    tmpV = x1;

    vote = 0;
    tmpMask = zeros(7, 7);
    for y = 1:1:7
        for x = 1:1:7
            x3 = p(y, x, :);
            flag = isVote(tmpD, tmpV, x3);
            if flag == 1;
                vote = vote + 1;
                tmpMask(y, x) = 1;
            end
        end
    end

    if vote > maxVote
        maxVote = vote;
        D = tmpD;
        V = tmpV;
        mask = tmpMask;
    end
    times = times + 1;
end

if sum(sum(mask)) < 0.6*7*7
    mask = zeros(7,7);
end

if D(:,:,1) < 0 || D(:,:,2) <0 || D(:,:,3) <0
    mask = zeros(7,7);
end

vecD = [D(:,:,1) D(:,:,2) <0 D(:,:,3)];
cos = dot(vecD, A)/norm(vecD)/norm(A);
theta = rad2deg(cos);
if theta < 15
    mask = zeros(7,7);
end
end

function [flag] = isVote(D, V, x)
vector = x - V;
vecvector = [vector(:,:,1),vector(:,:,2),vector(:,:,2)];
if norm(vecvector) == 0
    flag = 1;
    return;
end
normal = D;
vecnormal = [normal(:,:,1), normal(:,:,2), normal(:,:,3)];
cos = dot(vecvector,vecnormal)/norm(vecvector)/norm(vecnormal);
theta = pi / 2 - acos(cos);
proj = norm(vecvector) * cosd(rad2deg(theta));
if proj < 0.02
    flag  = 1;
else
    flag = 0;
end
end
