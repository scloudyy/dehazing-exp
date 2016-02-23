function result = calcRecover(input, transmission, ALight)
[height, width, ~] = size(input);

ALight_image = zeros(height, width, 3);

ALight_image(:,:,1) = ALight(1);
ALight_image(:,:,2) = ALight(2);
ALight_image(:,:,3) = ALight(3);

result(:,:,1) = (input(:,:,1) - ALight_image(:,:,1)) ./ transmission + ALight_image(:,:,1);
result(:,:,2) = (input(:,:,2) - ALight_image(:,:,2)) ./ transmission + ALight_image(:,:,2);
result(:,:,3) = (input(:,:,3) - ALight_image(:,:,3)) ./ transmission + ALight_image(:,:,3);

end