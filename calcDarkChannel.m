function darkchannel = calcDarkChannel(input)
[height, width, ~] = size(input);
darkchannel = zeros(height, width);
radius = round(min(height, width) * 0.02);
pixeldc = min(input, [], 3);
for i = 1:height
   for j = 1:width
      patch = pixeldc(max(1, i-radius):min(height, i+radius), ... 
                      max(1, j-radius):min(width, j+radius));
      darkchannel(i, j) = min(min(patch));
   end
end
end
