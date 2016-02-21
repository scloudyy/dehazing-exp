function ALight = calcAirlight(input, darkchannel)
[height, width, ~] = size(input);
ALight = zeros(1, 3);

count = 1;
vector_dc = repmat( struct('value', [], 'i', [], 'j', []), 1, height*width);
for i = 1:height
   for j = 1:width
       vector_dc(count).value = darkchannel(i,j);
       vector_dc(count).i = i;
       vector_dc(count).j = j;
       count = count + 1;
   end
end
count = count - 1;

fields = fieldnames(vector_dc);
cell_dc = struct2cell(vector_dc);
sz = size(cell_dc);
cell_dc = reshape(cell_dc, sz(1), []);
cell_dc = cell_dc';
cell_dc = sortrows(cell_dc, -1);
cell_dc = reshape(cell_dc', sz);
vector_dc = cell2struct(cell_dc, fields, 1);

ALight_mask = zeros(height, width);
ALight_image = input;

for i = 1:round(count*0.01)
    pixel = vector_dc(i);
    ALight_mask(pixel.i, pixel.j) = 255;
    
    ALight_image(pixel.i, pixel.j, 1) = 255;
    ALight_image(pixel.i, pixel.j, 2) = 0;
    ALight_image(pixel.i, pixel.j, 3) = 0;
end

lab = rgb2lab(input);
L = lab(:,:,1);
vector_L = repmat( struct('value', [], 'i', [], 'j', []), 1, round(count*0.01));

count_L = 1;
for i = 1:height
   for j = 1:width
      if ALight_mask(i, j) == 255
          vector_L(count_L).value = L(i,j);
          vector_L(count_L).i = i;
          vector_L(count_L).j = j;
          count_L = count_L + 1;
      end 
   end
end
count_L = count_L - 1;

fields = fieldnames(vector_L);
cell_L = struct2cell(vector_L);
sz = size(cell_L);
cell_L = reshape(cell_L, sz(1), []);
cell_L = cell_L';
cell_L = sortrows(cell_L, -1);
cell_L = reshape(cell_L', sz);
vector_L = cell2struct(cell_L, fields, 1);

ALight_mask_L = zeros(height, width);
pixel = vector_L(1);
ALight_mask_L(pixel.i, pixel.j) = 255;
    
for i = 2:round(count_L*0.001)
    pixel = vector_L(i);
    ALight_mask_L(pixel.i, pixel.j) = 255;
end

for i = 1:height
   for j = 1:width
      if ALight_mask_L(i,j) == 255
           ALight(1) = ALight(1) + input(i, j, 1);
           ALight(2) = ALight(2) + input(i, j, 2);
           ALight(3) = ALight(3) + input(i, j, 3);
      end
   end
end

ALight = ALight ./ round(count_L*0.001);

end