function [roughTrans, roughTrans_count, all] = calcTransmission(inputimg, A, fileNames)
% Calculate valid transmission
    [height, width, nch] = size(inputimg);
    trans(1:height,1:width) = -1;
    trans_count(1:height,1:width, 1:4) = 0;

    all_trans(1:height, 1:width, 1) = 1;
    all_trans(1:height, 1:width, 2:3) = 0;

    significant_line_support(1:height, 1:width, 1) = 1;
    significant_line_support(1:height, 1:width, 2:3) = 0;

    positive_reflectance(1:height, 1:width, 1) = 1;
    positive_reflectance(1:height, 1:width, 2:3) = 0;

    large_intersection_angle(1:height, 1:width, 1) = 1;
    large_intersection_angle(1:height, 1:width, 2:3) = 0;

    unimodality(1:height, 1:width, 1) = 1;
    unimodality(1:height, 1:width, 2:3) = 0;

    close_intersection(1:height, 1:width, 1) = 1;
    close_intersection(1:height, 1:width, 2:3) = 0;

    valid_transmission(1:height, 1:width, 1) = 1;
    valid_transmission(1:height, 1:width, 2:3) = 0;

    suffcient_shading_variability(1:height, 1:width, 1) = 1;
    suffcient_shading_variability(1:height, 1:width, 2:3) = 0;

    final_trans(1:height, 1:width, 1) = 1;
    final_trans(1:height, 1:width, 2:3) = 0;

    for i = 4:3:height-3
        for j = 4:3:width-3
            % if center pixel received enough estmates, escape
            if trans_count(i,j, 1) > 3
                continue;
            end
            p = inputimg(i-3:i+3, j-3:j+3, :); % p is the patch in img
            [D, V, mask] = calcColorLine(p);
            x = calcT(D, V, A); % to show how the patch be discaded, we should calculate t for every patch and then to test
            t = 1 - x(2,1);
            [all_trans(i-3:i+3, j-3:j+3, :), significant_line_support(i-3:i+3, j-3:j+3, :), positive_reflectance(i-3:i+3, j-3:j+3, :), large_intersection_angle(i-3:i+3, j-3:j+3, :), ...
             unimodality(i-3:i+3, j-3:j+3, :), close_intersection(i-3:i+3, j-3:j+3, :), valid_transmission(i-3:i+3, j-3:j+3, :), suffcient_shading_variability(i-3:i+3, j-3:j+3, :), ...
             final_trans(i-3:i+3, j-3:j+3, :), trans(i-3:i+3, j-3:j+3, :), trans_count(i-3:i+3, j-3:j+3, :)] = ...
                set_result(t, mask, x(1,1), x(2,1), D, V, A, p, all_trans(i-3:i+3, j-3:j+3, :), significant_line_support(i-3:i+3, j-3:j+3, :), positive_reflectance(i-3:i+3, j-3:j+3, :), large_intersection_angle(i-3:i+3, j-3:j+3, :), ...
                              unimodality(i-3:i+3, j-3:j+3, :), close_intersection(i-3:i+3, j-3:j+3, :), valid_transmission(i-3:i+3, j-3:j+3, :), suffcient_shading_variability(i-3:i+3, j-3:j+3, :), ...
                              final_trans(i-3:i+3, j-3:j+3, :), trans(i-3:i+3, j-3:j+3, :), trans_count(i-3:i+3, j-3:j+3, :));
        end
    end

    for i = 4:3:height-3
        j = width - 3;
        p = inputimg(i-3:i+3, j-3:j+3, :);
        [D, V, mask] = calcColorLine(p);
        x = calcT(D, V, A);
        t = 1 - x(2,1);
        [all_trans(i-3:i+3, j-3:j+3, :), significant_line_support(i-3:i+3, j-3:j+3, :), positive_reflectance(i-3:i+3, j-3:j+3, :), large_intersection_angle(i-3:i+3, j-3:j+3, :), ...
         unimodality(i-3:i+3, j-3:j+3, :), close_intersection(i-3:i+3, j-3:j+3, :), valid_transmission(i-3:i+3, j-3:j+3, :), suffcient_shading_variability(i-3:i+3, j-3:j+3, :), ...
         final_trans(i-3:i+3, j-3:j+3, :), trans(i-3:i+3, j-3:j+3, :), trans_count(i-3:i+3, j-3:j+3, :)] = ...
            set_result(t, mask, x(1,1), x(2,1), D, V, A, p, all_trans(i-3:i+3, j-3:j+3, :), significant_line_support(i-3:i+3, j-3:j+3, :), positive_reflectance(i-3:i+3, j-3:j+3, :), large_intersection_angle(i-3:i+3, j-3:j+3, :), ...
                          unimodality(i-3:i+3, j-3:j+3, :), close_intersection(i-3:i+3, j-3:j+3, :), valid_transmission(i-3:i+3, j-3:j+3, :), suffcient_shading_variability(i-3:i+3, j-3:j+3, :), ...
                          final_trans(i-3:i+3, j-3:j+3, :), trans(i-3:i+3, j-3:j+3, :), trans_count(i-3:i+3, j-3:j+3, :));
    end

    for j = 4:3:width-3
        i = height - 3;
        p = inputimg(i-3:i+3, j-3:j+3, :);
        [D, V, mask] = calcColorLine(p);
        x = calcT(D, V, A);
        t = 1 - x(2,1);
        [all_trans(i-3:i+3, j-3:j+3, :), significant_line_support(i-3:i+3, j-3:j+3, :), positive_reflectance(i-3:i+3, j-3:j+3, :), large_intersection_angle(i-3:i+3, j-3:j+3, :), ...
         unimodality(i-3:i+3, j-3:j+3, :), close_intersection(i-3:i+3, j-3:j+3, :), valid_transmission(i-3:i+3, j-3:j+3, :), suffcient_shading_variability(i-3:i+3, j-3:j+3, :), ...
         final_trans(i-3:i+3, j-3:j+3, :), trans(i-3:i+3, j-3:j+3, :), trans_count(i-3:i+3, j-3:j+3, :)] = ...
            set_result(t, mask, x(1,1), x(2,1), D, V, A, p, all_trans(i-3:i+3, j-3:j+3, :), significant_line_support(i-3:i+3, j-3:j+3, :), positive_reflectance(i-3:i+3, j-3:j+3, :), large_intersection_angle(i-3:i+3, j-3:j+3, :), ...
                          unimodality(i-3:i+3, j-3:j+3, :), close_intersection(i-3:i+3, j-3:j+3, :), valid_transmission(i-3:i+3, j-3:j+3, :), suffcient_shading_variability(i-3:i+3, j-3:j+3, :), ...
                          final_trans(i-3:i+3, j-3:j+3, :), trans(i-3:i+3, j-3:j+3, :), trans_count(i-3:i+3, j-3:j+3, :));

    end

    all = all_trans;
    all_trans = all_trans * 255;
    significant_line_support = significant_line_support * 255;
    positive_reflectance = positive_reflectance * 255;
    large_intersection_angle = large_intersection_angle * 255;
    unimodality = unimodality * 255;
    close_intersection = close_intersection * 255;
    valid_transmission = valid_transmission * 255;
    suffcient_shading_variability = suffcient_shading_variability * 255;
    final_trans = final_trans * 255;

    imwrite(uint8(all_trans), char(strcat('Result\', fileNames, '_all_trans.bmp')));
    imwrite(uint8(significant_line_support), char(strcat('Result\', fileNames, '_significant_line_support.bmp')));
    imwrite(uint8(positive_reflectance), char(strcat('Result\', fileNames, '_positive_reflectance.bmp')));
    imwrite(uint8(large_intersection_angle), char(strcat('Result\', fileNames, '_large_intersection_angle.bmp')));
    imwrite(uint8(unimodality), char(strcat('Result\', fileNames, '_unimodality.bmp')));
    imwrite(uint8(close_intersection), char(strcat('Result\', fileNames, '_close_intersection.bmp')));
    imwrite(uint8(valid_transmission), char(strcat('Result\', fileNames, '_valid_transmission.bmp')));
    imwrite(uint8(suffcient_shading_variability), char(strcat('Result\', fileNames, '_suffcient_shading_variability.bmp')));
    imwrite(uint8(final_trans), char(strcat('Result\', fileNames, '_final_trans.bmp')));

    roughTrans = trans;
    roughTrans_count = trans_count;
end

function [x] = calcT(D, V, A)
    matA = [norm(D)^2 -dot(A,D); -dot(A,D) norm(A)^2];
    matB = [-dot(D,V); dot(A,V)];
    x = bicg(matA, matB);
end

function [all_trans, significant_line_support, positive_reflectance, large_intersection_angle, ...
          unimodality, close_intersection, valid_transmission, suffcient_shading_variability, ...
          final_trans, trans, trans_count] = ...
        set_result(t, mask, l, s, D, V, A, I, all_trans, significant_line_support, positive_reflectance, large_intersection_angle, ...
                      unimodality, close_intersection, valid_transmission, suffcient_shading_variability, ...
                      final_trans, trans, trans_count)
    valid = 0; % count how many tests has patch passed
    all_trans(:, :, :) = show_t(t, mask, all_trans(:,:,:));

    flag = Significant_Line_Support(mask);
    if flag == 1
        significant_line_support(:, :, :) = show_t(t, mask, significant_line_support(:,:,:));
        valid = valid + 1;
    end

    flag = Positive_Reflectance(D);
    if flag == 1
        positive_reflectance(:, :, :) = show_t(t, mask, positive_reflectance(:,:,:));
        valid = valid + 1;
    end

    flag = Large_Intersection_Angle(D, A);
    if flag == 1
        large_intersection_angle(:, :, :) =  show_t(t, mask, large_intersection_angle(:,:,:));
        valid = valid + 1;
    end

    flag = Unimodality(I, D, V);
    if flag == 1
        unimodality(:, :, :) = show_t(t, mask, unimodality(:,:,:));
        valid = valid + 1;
    end

    flag = Close_Intersection(l, D, V, s, A);
    if flag == 1
        close_intersection(:, :, :) = show_t(t, mask, close_intersection(:,:,:));
        valid = valid + 1;
    end

    flag = Valid_Transmission(t);
    if flag == 1
        valid_transmission(:, :, :) = show_t(t, mask, valid_transmission(:,:,:));
        valid = valid + 1;
    end

    flag = Sufficient_Shading_Variability(I, V, D, t);
    if flag == 1
        suffcient_shading_variability(:, :, :) = show_t(t, mask, suffcient_shading_variability(:,:,:));
        valid = valid + 1;
    end

    if valid == 7
        final_trans(:, :, :) = show_t(t, mask, final_trans(:,:,:));
        theta = 0.01 * norm(A - D * dot(D,A)) * (1 - dot(D,A)^2)^(-1);
        [trans(:, :),trans_count(:, :, :)] = set_t(t, mask, trans(:,:), trans_count(:, :, :), theta);
    end
end

function [flag] = Significant_Line_Support(mask)
    [height, width, nch] = size(mask);
    if sum(sum(mask(:,:,1))) < 0.4 * height * width
        flag = 0;
    else
        flag = 1;
    end
end

function [flag] = Positive_Reflectance(D)
    if D(1) < 0 || D(2) < 0 || D(3) < 0
        flag = 0;
    else
        flag = 1;
    end
end

function [flag] = Large_Intersection_Angle(D, A)
    cos = dot(D, A)/norm(D)/norm(A);
    theta = rad2deg(cos);
    if theta < 15
        flag = 0;
    else
        flag = 1;
    end
end

function [flag] = Unimodality(I, D, V)
    [height, width, nch] = size(I);
    v = zeros(1, height * width);
    sum = 1;
    for i = 1:1:height
        for j = 1:1:width
            v(1, sum) = dot(I(i, j) - V, D);
            sum = sum + 1;
        end
    end
    MAX = max(v);
    MIN = min(v);
    if MAX == MIN
        flag = 1;
        return;
    end
    a = pi / (MAX -MIN);
    b = (pi * MIN) / (MIN - MAX);
    v = a * v + b;
    sum = 0;
    for i = 1:1:length(v)
        sum = sum + cos(v(i));
    end
    if sum / (height * width) > 0.07
        flag = 0;
    else
        flag = 1;
    end
end

function [flag] = Close_Intersection(l, D, V, s, A)
    vector = l * D + V - s * A;
    n = norm(vector)^2;
    if n > 0.05
        flag = 0;
    else
        flag = 1;
    end
end

function [flag] = Valid_Transmission(t)
    if t < 0 || t > 1
        flag = 0;
    else
        flag = 1;
    end
end

function [flag] = Sufficient_Shading_Variability(I, V, D, t)
    vecVar = zeros(1, 49);
    sum = 1;
    for i = 1:1:7
        for j = 1:1:7
            tmp = [I(i,j,1) I(i,j,2) I(i, j, 3)];
            vecVar(1, sum) = dot(tmp-V, D);
            sum = sum + 1;
        end
    end
    if std(vecVar) / t < 0.02
        flag = 0;
    else
        flag = 1;
    end
end

function [out_result, out_count] = set_t(t, mask, result, count, theta)
    [height,width, nch] = size(mask);
    for i = 1:1:height
        for j = 1:1:width
            if mask(i, j, 1) == 1
                count(i, j, 1) = count(i, j, 1) + 1;
                count(i, j, 2) = count(i, j, 2) + t;
            end
            count(i, j, 3) = count(i, j, 3) + 1;
            count(i, j, 4) = count(i, j, 4) + theta;
        end
    end
    for i = 1:1:height
        for j = 1:1:width
            if ~(count(i, j, 1) == 0)
                result(i ,j) = count(i, j, 2) / count(i, j, 1);
            end
        end
    end
    out_result = result;
    out_count = count;
end

function [output] = show_t(t, mask, result)
% show_t is used to show t on a three channel img
    [height, width, nch] = size(mask);
    for i = 1:1:height
        for j = 1:1:width
            if mask(i, j, 1) == 1
                result(i, j, :) = t;
            end
        end
    end
    output = result;
end