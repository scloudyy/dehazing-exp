function [D, V, mask] = calcColorLine(p)
%
%
    maxVote = -1;
    times = 0;
    while times <= 30
        x1 = floor(1 + (7 - 1) * rand(1, 1));
        y1 = floor(1 + (7 - 1) * rand(1, 1));

        x2 = floor(1 + (7 - 1) * rand(1, 1));
        y2 = floor(1 + (7 - 1) * rand(1, 1));

        vectmpD = [p(y2,x2,1) - p(y1,x1,1), p(y2,x2,2) - p(y1,x1,2), p(y2,x2,3) - p(y1,x1,3)];
        vectmpV = [p(y1,x1,1), p(y1,x1,2), p(y1,x1,3)];

        vote = 0;
        tmpMask = zeros(7, 7, 3);
        for y = 1:1:7
            for x = 1:1:7
                vecx3 = [p(y,x,1), p(y,x,2), p(y,x,3)];
                flag = isVote(vectmpD, vectmpV, vecx3);
                if flag == 1;
                    vote = vote + 1;
                    tmpMask(y, x,:) = 1;
                end
            end
        end

        if vote > maxVote
            maxVote = vote;
            D = vectmpD;
            V = vectmpV;
            mask = tmpMask;
        end
        times = times + 1;
    end
end

function [flag] = isVote(D, V, x)
    vector = x - V;
    if norm(vector) == 0
        flag = 1;
        return;
    end
    normal = D;
    cos = dot(vector,normal)/norm(vector)/norm(normal);
    theta = pi / 2 - acos(cos);
    proj = norm(vector) * cosd(rad2deg(theta));
    if proj < 0.02
        flag  = 1;
    else
        flag = 0;
    end
end
