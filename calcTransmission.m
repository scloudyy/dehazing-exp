function [roughTans] = calcTransmission(inputimg, A)
%
%
    [height, width, nch] = size(inputimg);
    trans(1:height,1:width) = -1;
    gray = rgb2gray(inputimg);
    edges = edge(gray, 'canny');

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

    final_colorline_trans(1:height, 1:width, 1) = 1;
    final_colorline_trans(1:height, 1:width, 2:3) = 0;

    close_intersection(1:height, 1:width, 1) = 1;
    close_intersection(1:height, 1:width, 2;3) = 0;

    valid_transmission(1:height, 1:width, 1) = 1;
    valid_transmission(1:height, 1:width, 2:3) = 0;

    suffcient_shading_variability(1;height, 1:width, 1) = 1;
    suffcient_shading_variability(1;height, 1:width, 2:3) = 0;

    final_trans(1:height, 1:width, 1:3) = 0;

    for i = 4:3:height-4
        for j = 4:3:width-4
            valid = 0;
            valid2 = 0;

            p = inputimg(i-3:i+3, j-3:j+3, :);
            [D, V, mask] = calcColorLine(p, A);
            x = calcT(D, V, A);
            t = 1 - x(2,1);

            all_trans(i, j, :) = t;

            flag = Significant_Line_Support(mask);
            if flag == 1
                significant_line_support(i, j, :) = t;
                valid = valid + 1;
            end

            flag = Positive_Reflectance(D);
            if flag == 1
                positive_reflectance(i, j, :) = t;
                valid = valid + 1;
            end

            flag = Large_Intersection_Angle(D, A);
            if flag == 1
                large_intersection_angle(i, j, :) = t;
                valid = valid + 1;
            end

            if valid == 3
                final_colorline_trans(i, j, :) = t;

                flag = Close_Intersection(l, D, V, s,A);
                if flag == 1
                    close_intersection(i, j, :) = t;
                    valid2 = valid2 + 1;
                end

                flag = Valid_Transmission(t)
                if flag == 1
                    Valid_Transmission(i, j, :) = t;
                    valid2 = valid2 + 1;
                end

                flag = Sufficient_Shading_Variability(p, V, D, t, mask);
                if flag == 1
                    sufficient_shading_variability(i, j, :) = t;
                    valid2 = valid2 + 1;
                end

                if valid2 == 3
                    final_trans(i, j, :) = t;
                    trans(i, j) = t;
                end
            end
        end
    end
    roughTans = trans;
end

function [x] = calcT(D, V, A)
    matA = [norm(D)^2 -dot(A,D); -dot(A,D) norm(A)^2];
    matB = [-dot(D,V); dot(A,V)];
    x = bicg(matA, matB);
end

function [flag] = Significant_Line_Support(mask)
    [height, width, nch] = size(mask);
    if sum(sum(mask)) < 0.4 * height * width
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

function [flag] = Sufficient_Shading_variability(I, V, D, t, mask)
    vecVar = [];
    for i = 1:1:7
        for j = 1:1:7
            if mask(i, j) == 1
                tmp = [I(i,j,1) I(i,j,2) I(i, j, 3)];
                vecVar = [vecVar dot(tmp-V, D)];
            end
        end
    end
    if std(vecVar) / t < 0.02
        flag = 0;
    else
        flag = 1;
    end
end