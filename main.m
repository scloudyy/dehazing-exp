clear;

fileFolder=fullfile('E:\WorkPlace\Code\matlab\colorline');
fileFolder_img = char(strcat(fileFolder, '\img'));
dirOutput=dir(fullfile(fileFolder_img,'*'));
fileNames={dirOutput.name};

flag_calc_load = 0; % a flag denote whether calculate colorlines again

for i = 1:1:length(fileNames)
    if sum(strfind(char(fileNames(i)), 'bmp')) || sum(strfind(char(fileNames(i)), 'jpg')) || sum(strfind(char(fileNames(i)), 'png'))
        input = im2double(imread(char(strcat('img\', fileNames(i)))));
        [height, width, nch] = size(input);
        darkchannel = calcDarkChannel(input);
        ALight = calcAirlight(input, darkchannel);
        if flag_calc_load == 1  % calculate 
            [roughTrans, Trans_count, allRoughTrans] = calcTransmission(input, ALight, fileNames(i));
            save(char(strcat('Result\', fileNames(i), '_roughTrans.mat')), 'roughTrans');
            save(char(strcat('Result\', fileNames(i), '_Trans_count.mat')), 'Trans_count');
            save(char(strcat('Result\', fileNames(i), '_allRoughTrans.mat')), 'allRoughTrans');
        else % load data directly
            roughTrans = load(char(strcat('Result\', fileNames(i), '_roughTrans.mat')));
            roughTrans = roughTrans.roughTrans;
            Trans_count = load(char(strcat('Result\', fileNames(i), '_Trans_count.mat')));
            Trans_count = Trans_count.Trans_count;
            allRoughTrans = load(char(strcat('Result\', fileNames(i), '_allRoughTrans.mat')));
            allRoughTrans = allRoughTrans.allRoughTrans;
        end
        cut_trans = cutTrans( roughTrans ); % let t don't close to 0, else recover will appear mistake
        [A, B] = calcSparse(input, cut_trans, Trans_count); % get sparse A B
        rec_T = calcRestructT(A, B, height, width, fileNames(i));
        output = calcRecover(input, rec_T, ALight);
        imwrite(uint8(output), char(strcat('Result\', fileNames(i), '_output.bmp')));
    end
end