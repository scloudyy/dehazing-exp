input = imread('1.bmp');
input = im2double(input);
darkchannel = calcDarkChannel(input);
A = calcAirlight(input, darkchannel);
roughTrans = calcTransmission(input, A);
save('roughTrans.mat', 'roughTrans');
transmission = iteration(roughTrans, input);
output = calcRecover(input, transmission, A);
imwrite(output, 'output.bmp');