function [A, B] = calcSparse(I, t, trans_count)
% Get Sparse matrix A, B
    [height, width, nch] = size(t);
    A = sparse(height * width, height * width);
    B = sparse(height * width, 1);
    fp = fopen('A.txt', 'w+');
    fpb = fopen('B.txt', 'w+');
    sum = 1;
    for i = 1:1:height
        for j = 1:1:width
            % for every pixels calculate up, down, right, left, center, b
            % and distant respectively
            [up, down, right, left, center, b, distant, d_i, d_j] = calcV(I, t, i, j, height, width, trans_count);
            if ~(up == 0)
                A(sum, (i - 2) * width + j) = A(sum, (i - 2) * width + j) + up;
                fprintf(fp, '(%d, %d, %d)\n', sum, (i - 2) * width + j, up);
            end
            if ~(down == 0)
                A(sum, i * width + j) = A(sum, i * width + j) + down;
                fprintf(fp, '(%d, %d, %d)\n', sum, i * width + j, down);
            end
            if ~(left == 0)
                A(sum, (i - 1) * width + j - 1) = A(sum, (i - 1) * width + j - 1) + left;
                fprintf(fp, '(%d, %d, %d)\n', sum, (i - 1) * width + j - 1, left);
            end
            if ~(right == 0)
                A(sum, (i - 1) * width + j + 1) =  A(sum, (i - 1) * width + j + 1) + right;
                fprintf(fp, '(%d, %d, %d)\n', sum, (i - 1) * width + j + 1, right);
            end
            if ~(distant == 0)
                A(sum, (d_i - 1) * width + d_j) =  A(sum, (d_i - 1) * width + d_j) + distant;
                fprintf(fp, '(%d, %d, %d)\n', sum, (i - 1) * width + j + 1, distant);
            end
            A(sum, sum) = A(sum, sum) + center;
            fprintf(fp, '(%d, %d, %d)\n', sum, sum, center);
            B(sum , 1) = B(sum , 1) + b;
            fprintf(fpb, '(%d, %d, %d)\n', sum, 1, b);
            sum = sum + 1;
        end
    end
end

function [up, down, right, left, center, b, distant, d_i, d_j] = calcV(I, t, i, j, height, width, trans_count)
    up = 0;
    down = 0;
    right = 0;
    left = 0;
    center = 0;
    b = 0;
    distant = 0;d_i = 0;d_j = 0;
    if i - 1 >= 1
        v = [I(i, j, 1) - I(i - 1, j, 1), I(i, j, 2) - I(i - 1, j, 2), I(i, j, 3) - I(i - 1, j, 3)];
        v = norm(v)^2;
        if v == 0
            v = 1e+05;
        else
            v = 1 / v;
        end
        center = center + v;
        up = -v;
    end

    if i + 1 <= height
        v = [I(i, j, 1) - I(i + 1, j, 1), I(i, j, 2) - I(i + 1, j, 2), I(i, j, 3) - I(i + 1, j, 3)];
        v = norm(v)^2;
        if v == 0
            v = 1e+05;
        else
            v = 1 / v;
        end
        center = center + v;
        down = -v;
    end

    if j - 1 >= 1
        v = [I(i, j, 1) - I(i, j - 1, 1), I(i, j, 2) - I(i, j - 1, 2), I(i, j, 3) - I(i, j - 1, 3)];
        v = norm(v)^2;
        if v == 0
            v = 1e+05;
        else
            v = 1 / v;
        end
        center = center + v;
        left = -v;
    end

    if j + 1 <= width
        v = [I(i, j, 1) - I(i, j + 1, 1), I(i, j, 2) - I(i, j + 1, 2), I(i, j, 3) - I(i, j + 1, 3)];
        v = norm(v)^2;
        if v == 0
            v = 1e+05;
        else
            v = 1 / v;
        end
        center = center + v;
        right = -v;
    end

    % if pixel has an transmission, then center and b should be changed
    if ~(t(i, j) == -1)
        center = center + 1 / (trans_count(i, j, 4) / trans_count(i, j, 3))^2;
        b = b + t(i, j) / (trans_count(i, j, 4) / trans_count(i, j, 3))^2;
    end
    
    % In inplementation only subsample every fourth pixel in each
    % axis for Markov
    if mod(i, 4) || mod(j, 4)
        return;
    end

    % first get patch's coordinate
    [height, width, nch] = size(I);
    p_height = 0.15 * height;
    p_width = 0.15 * width;
    i_up = round(i - p_height / 2);
    if i_up < 1
        i_up = 1;
    end
    i_down = round(i + p_height / 2);
    if i_down > height
        i_down = height;
    end
    j_left = round(j - p_width / 2);
    if j_left < 1
        j_left = 1;
    end
    j_right = round(j + p_width / 2);
    if j_right > height
        j_right = height;
    end

    % In implementation, stop searchafter five unsuccessful attempts
    times = 0;
    while ~(times == 5)
        x = floor(1 + (j_right - j_left) * rand(1, 1));
        y = floor(1 + (i_down - i_up) * rand(1, 1));
        if x == j && y == i
            continue;
        end
        v = [I(i, j, 1) - I(y, x, 1), I(i, j, 2) - I(y, x, 2), I(i, j, 3) - I(y, x, 3)];
        if norm(v) < 0.1
            v = norm(v)^2;
            if v == 0
                v = 1e+05;
            else
                v = 1 / v;
            end
            center = center + v;
            distant = -v;
            d_i = y;
            d_j = x;
            return;
        end
        times = times + 1;
    end
end

