input = imread('1.bmp');
input = im2double(input);
darkchannel = calcDarkChannel(input);
figure;imshow(darkchannel);
A = calcAirlight(input, darkchannel);
roughTrans = calcTransmission(input, A);
figure;imshow(roughTrans);
